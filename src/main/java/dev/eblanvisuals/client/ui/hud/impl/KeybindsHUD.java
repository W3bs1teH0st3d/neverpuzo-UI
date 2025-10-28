package dev.eblanvisuals.client.ui.hud.impl;

import dev.eblanvisuals.client.events.impl.EventRender2D;
import dev.eblanvisuals.client.ui.hud.HudElement;
import dev.eblanvisuals.client.util.renderer.Render2D;
import dev.eblanvisuals.client.util.renderer.fonts.Fonts;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.EblanVisuals;
import org.lwjgl.glfw.GLFW;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

/**
 * Neverlose-style Keybinds HUD
 * Показывает активные кейбинды модулей
 */
public class KeybindsHUD extends HudElement {

    private static final Color BG_COLOR = new Color(17, 17, 22, 240);
    private static final Color HEADER_BG = new Color(22, 22, 28, 255);
    private static final Color TEXT_COLOR = new Color(255, 255, 255, 255);
    private static final Color KEY_COLOR = new Color(139, 158, 255, 255);
    private static final Color SEPARATOR_COLOR = new Color(40, 40, 50, 255);

    private float totalWidth = 120f;
    private float totalHeight;

    public KeybindsHUD() {
        super("KeybindsHUD");
    }

    @Override
    public void onRender2D(EventRender2D e) {
        if (fullNullCheck() || closed()) return;

        var matrices = e.getContext().getMatrices();

        // Собираем активные модули с кейбиндами
        List<Module> activeModules = new ArrayList<>();
        for (Module module : EblanVisuals.getInstance().getModuleManager().getModules()) {
            if (module.isToggled() && module.getBind().getKey() != GLFW.GLFW_KEY_UNKNOWN) {
                activeModules.add(module);
            }
        }

        float fontSize = 8f;
        float padding = 8f;
        float headerHeight = 22f;
        float itemHeight = 18f;
        float minWidth = 120f;

        // Вычисляем размеры
        float maxNameWidth = 0f;
        for (Module module : activeModules) {
            float nameWidth = Fonts.REGULAR.getWidth(module.getName(), fontSize);
            maxNameWidth = Math.max(maxNameWidth, nameWidth);
        }

        totalWidth = Math.max(minWidth, maxNameWidth + padding * 3 + 40f);
        totalHeight = headerHeight + (activeModules.isEmpty() ? 0 : activeModules.size() * itemHeight) + padding;

        setBounds(getX(), getY(), totalWidth, totalHeight);

        // Фон
        Render2D.drawRoundedRect(
                matrices,
                getX(), getY(),
                totalWidth, totalHeight,
                6f,
                BG_COLOR
        );

        // Header
        Render2D.drawRoundedRect(
                matrices,
                getX(), getY(),
                totalWidth, headerHeight,
                6f,
                HEADER_BG
        );

        // Заголовок "Binds"
        String title = "Binds";
        float titleX = getX() + padding;
        float titleY = getY() + (headerHeight - Fonts.BOLD.getHeight(9f)) / 2f;
        
        Render2D.drawFont(
                matrices,
                Fonts.BOLD.getFont(9f),
                title,
                titleX,
                titleY,
                TEXT_COLOR
        );

        // Separator line
        Render2D.drawRect(
                matrices,
                getX(),
                getY() + headerHeight,
                totalWidth,
                1f,
                SEPARATOR_COLOR
        );

        // Рисуем список кейбиндов
        if (!activeModules.isEmpty()) {
            float itemY = getY() + headerHeight + 4f;

            for (Module module : activeModules) {
                String moduleName = module.getName();
                String keyName = getKeyName(module.getBind().getKey());

                float nameX = getX() + padding;
                float keyX = getX() + totalWidth - padding - Fonts.REGULAR.getWidth(keyName, fontSize);
                float textY = itemY + (itemHeight - Fonts.REGULAR.getHeight(fontSize)) / 2f;

                // Module name
                Render2D.drawFont(
                        matrices,
                        Fonts.REGULAR.getFont(fontSize),
                        moduleName,
                        nameX,
                        textY,
                        TEXT_COLOR
                );

                // Key name с акцентом
                Render2D.drawFont(
                        matrices,
                        Fonts.REGULAR.getFont(fontSize),
                        keyName,
                        keyX,
                        textY,
                        KEY_COLOR
                );

                itemY += itemHeight;
            }
        }

        super.onRender2D(e);
    }

    private String getKeyName(int key) {
        if (key == GLFW.GLFW_KEY_UNKNOWN) return "NONE";
        
        String name = GLFW.glfwGetKeyName(key, 0);
        if (name != null) {
            return name.toUpperCase();
        }

        // Fallback для специальных клавиш
        return switch (key) {
            case GLFW.GLFW_KEY_SPACE -> "SPACE";
            case GLFW.GLFW_KEY_LEFT_SHIFT -> "LSHIFT";
            case GLFW.GLFW_KEY_RIGHT_SHIFT -> "RSHIFT";
            case GLFW.GLFW_KEY_LEFT_CONTROL -> "LCTRL";
            case GLFW.GLFW_KEY_RIGHT_CONTROL -> "RCTRL";
            case GLFW.GLFW_KEY_LEFT_ALT -> "LALT";
            case GLFW.GLFW_KEY_RIGHT_ALT -> "RALT";
            case GLFW.GLFW_KEY_TAB -> "TAB";
            case GLFW.GLFW_KEY_CAPS_LOCK -> "CAPS";
            case GLFW.GLFW_KEY_ESCAPE -> "ESC";
            case GLFW.GLFW_KEY_ENTER -> "ENTER";
            case GLFW.GLFW_KEY_BACKSPACE -> "BACK";
            default -> "KEY" + key;
        };
    }
}
