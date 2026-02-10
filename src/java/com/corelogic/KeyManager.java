package com.corelogic;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class KeyManager implements ServletContextListener {
    private static final String ATTRIBUTE_NAME = "encryptionKey";
    private static final String KEY_FILE = "secret.key";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            SecretKey key = loadOrGenerateKey(sce.getServletContext());
            sce.getServletContext().setAttribute(ATTRIBUTE_NAME, key);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize encryption key", e);
        }
    }

    private SecretKey loadOrGenerateKey(ServletContext context) throws Exception {
        String homeDir = System.getProperty("user.home");
        String keyPath = homeDir + File.separator + KEY_FILE;
        File keyFile = new File(keyPath);

        if (keyFile.exists()) {
            System.out.println("Loading existing encryption key from " + keyPath);
            byte[] keyBytes = Files.readAllBytes(Paths.get(keyPath));
            return new SecretKeySpec(keyBytes, "AES");
        } else {
            System.out.println("Generating new encryption key at " + keyPath);
            SecretKey key = EncryptionUtil.generateKey();
            try (FileOutputStream fos = new FileOutputStream(keyFile)) {
                fos.write(key.getEncoded());
            }
            return key;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // No cleanup needed
    }

    public static SecretKey getKey(ServletContext context) {
        return (SecretKey) context.getAttribute(ATTRIBUTE_NAME);
    }
}
