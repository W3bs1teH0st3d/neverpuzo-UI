using System;
using System.IO;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace Shared
{
    /// <summary>
    /// Secure certificate management using .NET built-in APIs
    /// No BouncyCastle dependency - no RCE vulnerability
    /// </summary>
    public static class SecureCertificate
    {
        private const string CERT_FILE = "eblanrat_cert.pfx";
        private const string CERT_PASSWORD = "EblanRAT_Secure_2024";
        
        /// <summary>
        /// Generate or load server certificate
        /// </summary>
        public static X509Certificate2 GetOrCreateServerCertificate()
        {
            // Try to load existing certificate
            if (File.Exists(CERT_FILE))
            {
                try
                {
                    return new X509Certificate2(CERT_FILE, CERT_PASSWORD, 
                        X509KeyStorageFlags.Exportable | X509KeyStorageFlags.PersistKeySet);
                }
                catch
                {
                    // If loading fails, regenerate
                    File.Delete(CERT_FILE);
                }
            }

            // Generate new certificate
            return GenerateServerCertificate();
        }

        /// <summary>
        /// Generate self-signed certificate using .NET 5+ APIs
        /// </summary>
        private static X509Certificate2 GenerateServerCertificate()
        {
            // Generate RSA key pair
            using var rsa = RSA.Create(4096);
            
            // Create certificate request
            var request = new CertificateRequest(
                "CN=EblanRAT Server",
                rsa,
                HashAlgorithmName.SHA256,
                RSASignaturePadding.Pkcs1
            );

            // Add extensions
            request.CertificateExtensions.Add(
                new X509KeyUsageExtension(
                    X509KeyUsageFlags.DigitalSignature | X509KeyUsageFlags.KeyEncipherment,
                    critical: true
                )
            );

            request.CertificateExtensions.Add(
                new X509EnhancedKeyUsageExtension(
                    new OidCollection 
                    { 
                        new Oid("1.3.6.1.5.5.7.3.1") // Server Authentication
                    },
                    critical: true
                )
            );

            request.CertificateExtensions.Add(
                new X509SubjectKeyIdentifierExtension(request.PublicKey, critical: false)
            );

            // Create self-signed certificate
            var certificate = request.CreateSelfSigned(
                DateTimeOffset.UtcNow.AddDays(-1),
                DateTimeOffset.UtcNow.AddYears(10)
            );

            // Export with private key
            var certWithKey = new X509Certificate2(
                certificate.Export(X509ContentType.Pfx, CERT_PASSWORD),
                CERT_PASSWORD,
                X509KeyStorageFlags.Exportable | X509KeyStorageFlags.PersistKeySet
            );

            // Save to file
            File.WriteAllBytes(CERT_FILE, certWithKey.Export(X509ContentType.Pfx, CERT_PASSWORD));

            return certWithKey;
        }

        /// <summary>
        /// Validate client certificate (for mutual TLS if needed)
        /// </summary>
        public static bool ValidateClientCertificate(X509Certificate2 certificate, X509Chain chain)
        {
            if (certificate == null)
                return false;

            // For now, accept any certificate (can be enhanced with pinning)
            // In production, implement proper certificate validation
            return true;
        }

        /// <summary>
        /// Get certificate thumbprint for validation
        /// </summary>
        public static string GetCertificateThumbprint(X509Certificate2 certificate)
        {
            return certificate?.Thumbprint ?? string.Empty;
        }

        /// <summary>
        /// Delete certificate file (for regeneration)
        /// </summary>
        public static void DeleteCertificate()
        {
            if (File.Exists(CERT_FILE))
            {
                File.Delete(CERT_FILE);
            }
        }
    }
}
