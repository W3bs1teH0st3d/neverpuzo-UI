package dev.eblanvisuals.modules.impl.render;

import dev.eblanvisuals.client.events.impl.EventRender2D;
import dev.eblanvisuals.client.managers.ThemeManager;
import dev.eblanvisuals.client.util.renderer.Render2D;
import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.BooleanSetting;
import dev.eblanvisuals.modules.settings.impl.NumberSetting;
import meteordevelopment.orbit.EventHandler;
import net.minecraft.util.hit.HitResult;

import java.awt.*;

public class Crosshair extends Module implements ThemeManager.ThemeChangeListener {

    private static Crosshair instance; // Для доступа через Mixin

    private final NumberSetting thickness = new NumberSetting("Толщина", 1f, 0.5f, 3f, 0.1f);
    private final NumberSetting length = new NumberSetting("Длина", 3f, 1f, 8f, 0.5f);
    private final NumberSetting gap = new NumberSetting("Разрыв", 2f, 0f, 5f, 0.5f);
    private final BooleanSetting dynamicGap = new BooleanSetting("Динамический разрыв", false);
    private final BooleanSetting useEntityColor = new BooleanSetting("Цвет при наведении", false);

    private final ThemeManager themeManager;
    private Color currentColor;
    private final Color entityColor = new Color(255, 0, 0);

    public Crosshair() {
        super("Crosshair", Category.Render, "Кастомный прицел");
        instance = this;
        themeManager = ThemeManager.getInstance();
        currentColor = themeManager.getThemeColor(); // Предполагаем, что ThemeManager имеет getThemeColor()
        themeManager.addThemeChangeListener(this);
    }

    public static Crosshair getInstance() {
        return instance;
    }

    @EventHandler
    public void onRender2D(EventRender2D e) {
        if (mc.player == null || mc.world == null) return;

        // Проверка режима F5 (от третьего лица)
        if (!mc.options.getPerspective().isFirstPerson()) {
            return; // Не рендерим прицел в режиме от третьего лица
        }

        // Кэшируем размеры окна и повторно используем значения
        int sw = mc.getWindow().getScaledWidth();
        int sh = mc.getWindow().getScaledHeight();
        float x = sw * 0.5f;
        float y = sh * 0.5f;

        float currentGap = gap.getValue();
        if (dynamicGap.getValue()) {
            float cooldown = 1f - mc.player.getAttackCooldownProgress(0);
            currentGap = Math.min(currentGap + 8f * cooldown, 10f); // Ограничение разрыва
        }

        float w = thickness.getValue();
        float l = length.getValue();

        // Используем цвет темы, если не включен цвет при наведении на сущность
        Color color = currentColor;
        if (useEntityColor.getValue() && mc.crosshairTarget != null && mc.crosshairTarget.getType() == HitResult.Type.ENTITY) {
            color = entityColor;
        }

        var matrices = e.getContext().getMatrices();
        Render2D.drawRect(matrices, x - w / 2, y - currentGap - l, w, l, color);
        Render2D.drawRect(matrices, x - w / 2, y + currentGap, w, l, color);
        Render2D.drawRect(matrices, x - currentGap - l, y - w / 2, l, w, color);
        Render2D.drawRect(matrices, x + currentGap, y - w / 2, l, w, color);
    }

    @Override
    public void onThemeChanged(ThemeManager.Theme theme) {
        this.currentColor = theme.getBackgroundColor(); // Используем getBackgroundColor(), как в BlockOverlay
    }

    @Override
    public void onDisable() {
        themeManager.removeThemeChangeListener(this);
        super.onDisable();
    }
}