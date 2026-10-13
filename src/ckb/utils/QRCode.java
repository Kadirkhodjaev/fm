package ckb.utils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.EnumMap;
import java.util.Map;

public class QRCode {

  public static byte[] generateUrlQrPng(String url, int size) {
    if (url == null || url.trim().isEmpty()) {
      throw new IllegalArgumentException("url is empty");
    }
    // Важно: чтобы телефоны распознавали как ссылку
    if (!(url.startsWith("http://") || url.startsWith("https://"))) {
      throw new IllegalArgumentException("URL must start with http:// or https://");
    }
    if (size <= 0) {
      throw new IllegalArgumentException("size must be > 0");
    }

    Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
    hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
    hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
    hints.put(EncodeHintType.MARGIN, 1);

    try {
      BitMatrix matrix = new MultiFormatWriter()
        .encode(url, BarcodeFormat.QR_CODE, size, size, hints);

      BufferedImage image = MatrixToImageWriter.toBufferedImage(matrix);

      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      ImageIO.write(image, "PNG", baos);
      return baos.toByteArray();
    } catch (Exception e) {
      throw new IllegalStateException("QR generation failed", e);
    }
  }
}
