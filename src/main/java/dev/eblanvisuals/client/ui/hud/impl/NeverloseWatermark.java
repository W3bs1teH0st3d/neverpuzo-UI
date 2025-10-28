package dev.eblanvisuals.client.ui.hud.impl;

import dev.eblanvisuals.client.events.impl.EventRender2D;
import dev.eblanvisuals.client.ui.hud.HudElement;
import dev.eblanvisuals.client.util.renderer.Render2D;
import dev.eblanvisuals.client.util.renderer.fonts.Fonts;
import dev.eblanvisuals.client.util.perf.Perf;
import net.minecraft.client.MinecraftClient;

import java.awt.Color;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Neverlose-style Watermark with indicators
 * Показывает: NL | Exration | [E] HvH | 340 fps | 21:33:19
 */
public class NeverloseWatermark extends HudElement {

    private static final Color BG_COLOR = new Color(17, 17, 22, 240);
    private static final Color TEXT_COLOR = new Color(255, 255, 255, 255);
    private static final Color ACCENT_COLOR = new Color(139, 158, 255, 255);
    private static final Color SEPARATOR_COLOR = new Color(60, 60, 70, 255);

    private float totalWidth, totalHeight;
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");

    public NeverloseWatermark() {
        super("NeverloseWatermark");
    }

    @Override
    public void onRender2D(EventRender2D e) {
        if (fullNullCheck() || closed()) return;
        Perf.tryBeginFrame();
        try (var __ = Perf.scopeCpu("NeverloseWatermark.onRender2D")) {

            var matrices = e.getContext().getMatrices();
            MinecraftClient mc = MinecraftClient.getInstance();

            // Данные для отображения
            String logo = "NL";
            String serverName = "Exration"; // можно заменить на реальный сервер
            String mode = "[E] HvH"; // режим игры
            String fps = mc.getCurrentFps() + " fps";
            String time = timeFormat.format(new Date());

            float fontSize = 7.5f;
            float padding = 6f;
            float separatorWidth = 1f;
            float separatorPadding = 8f;

            // Вычисляем ширину каждого элемента
            float logoW = Fonts.BOLD.getWidth(logo, fontSize);
            float serverW = Fonts.REGULAR.getWidth(serverName, fontSize);
            float modeW = Fonts.REGULAR.getWidth(mode, fontSize);
            float fpsW = Fonts.REGULAR.getWidth(fps, fontSize);
            float timeW = Fonts.REGULAR.getWidth(time, fontSize);

            // Общая ширина с разделителями
            totalWidth = padding * 2 + logoW + separatorPadding + separatorWidth + separatorPadding +
                    serverW + separatorPadding + separatorWidth + separatorPadding +
                    modeW + separatorPadding + separatorWidth + separatorPadding +
                    fpsW + separatorPadding + separatorWidth + separatorPadding + timeW;
            
            totalHeight = padding * 2 + Fonts.REGULAR.getHeight(fontSize);

            setBounds(getX(), getY(), totalWidth, totalHeight);

            // Фон
            Render2D.drawRoundedRect(
                    matrices,
                    getX(), getY(),
                    totalWidth, totalHeight,
                    4f,
                    BG_COLOR
            );

            float currentX = getX() + padding;
            float textY = getY() + (totalHeight - Fonts.REGULAR.getHeight(fontSize)) / 2f;

            // Logo "NL" с акцентным цветом
            Render2D.drawFont(
                    matrices,
                    Fonts.BOLD.getFont(fontSize),
                    logo,
                    currentX,
                    textY,
                    ACCENT_COLOR
            );
            currentX += logoW + separatorPadding;

            // Разделитель
            Render2D.drawRect(
                    matrices,
                    currentX,
                    getY() + padding - 1f,
                    separatorWidth,
                    totalHeight - padding * 2 + 2f,
                    SEPARATOR_COLOR
            );
            currentX += separatorWidth + separatorPadding;

            // Server name
            Render2D.drawFont(
                    matrices,
                    Fonts.REGULAR.getFont(fontSize),
                    serverName,
                    currentX,
                    textY,
                    TEXT_COLOR
            );
            currentX += serverW + separatorPadding;

            // Разделитель
            Render2D.drawRect(
                    matrices,
                    currentX,
                    getY() + padding - 1f,
                    separatorWidth,
                    totalHeight - padding * 2 + 2f,
                    SEPARATOR_COLOR
            );
            currentX += separatorWidth + separatorPadding;

            // Mode
            Render2D.drawFont(
                    matrices,
                    Fonts.REGULAR.getFont(fontSize),
                    mode,
                    currentX,
                    textY,
                    TEXT_COLOR
            );
            currentX += modeW + separatorPadding;

            // Разделитель
            Render2D.drawRect(
                    matrices,
                    currentX,
                    getY() + padding - 1f,
                    separatorWidth,
                    totalHeight - padding * 2 + 2f,
                    SEPARATOR_COLOR
            );
            currentX += separatorWidth + separatorPadding;

            // FPS
            Render2D.drawFont(
                    matrices,
                    Fonts.REGULAR.getFont(fontSize),
                    fps,
                    currentX,
                    textY,
                    TEXT_COLOR
            );
            currentX += fpsW + separatorPadding;

            // Разделитель
            Render2D.drawRect(
                    matrices,
                    currentX,
                    getY() + padding - 1f,
                    separatorWidth,
                    totalHeight - padding * 2 + 2f,
                    SEPARATOR_COLOR
            );
            currentX += separatorWidth + separatorPadding;

            // Time
            Render2D.drawFont(
                    matrices,
                    Fonts.REGULAR.getFont(fontSize),
                    time,
                    currentX,
                    textY,
                    TEXT_COLOR
            );

            super.onRender2D(e);
        }
    }
}
