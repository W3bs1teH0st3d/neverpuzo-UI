package dev.eblanvisuals.modules.impl.render;

import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.NumberSetting;

public class HitColor extends Module {

    public final NumberSetting alpha = new NumberSetting("setting.alpha", 0.8f, 0.1f, 1.0f, 0.05f);

    public HitColor() {
        super("HitColor", Category.Render, "module.hitcolor.description");
    }
}
