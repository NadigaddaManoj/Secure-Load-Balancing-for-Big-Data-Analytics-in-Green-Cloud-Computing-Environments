package com.corelogic;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Arrays;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;
import java.util.logging.Level;

public class EncryptionUtil {
    private static final int AES_KEY_BITS = 128;  // UPGRADE TO 256-bit (JDK8 compatible)
    private static final int GCM_TAG_LEN = 128;
    private static final int GCM_IV_LEN = 12;
    private static final Logger LOGGER = Logger.getLogger(EncryptionUtil.class.getName());

    public static SecretKey generateKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(AES_KEY_BITS);
        return kg.generateKey();
    }

    public static String encrypt(SecretKey key, String plain) throws Exception {
        if (plain == null || plain.isEmpty()) return "";
        byte[] iv = new byte[GCM_IV_LEN];
        new SecureRandom().nextBytes(iv);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LEN, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] ct = cipher.doFinal(plain.getBytes(StandardCharsets.UTF_8));
        byte[] out = new byte[iv.length + ct.length];
        System.arraycopy(iv, 0, out, 0, iv.length);
        System.arraycopy(ct, 0, out, iv.length, ct.length);
        return Base64.getEncoder().encodeToString(out);
    }

    public static String decrypt(SecretKey key, String cipherTextB64) throws Exception {
        if (cipherTextB64 == null || cipherTextB64.isEmpty()) return "";
        
        byte[] in = Base64.getDecoder().decode(cipherTextB64);
        if (in.length < GCM_IV_LEN + 16) { // Minimum for IV + tag
            LOGGER.warning("Invalid ciphertext length: " + in.length);
            throw new Exception("Invalid encrypted data format");
        }
        
        byte[] iv = Arrays.copyOfRange(in, 0, GCM_IV_LEN);
        byte[] ct = Arrays.copyOfRange(in, GCM_IV_LEN, in.length);
        
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LEN, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, spec);
        byte[] pt = cipher.doFinal(ct);
        return new String(pt, StandardCharsets.UTF_8);
    }
}