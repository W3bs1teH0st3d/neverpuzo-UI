package dev.eblanvisuals.modules.impl.render;

import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.NumberSetting;
import net.minecraft.client.resource.language.I18n;

public class TimeChanger extends Module {
    public TimeChanger(){
        super("TimeChanger", Category.Render, I18n.translate("module.timechanger.description"));
    }
    public final NumberSetting Time = new NumberSetting("setting.time", 12f, 1f, 24f, 0.5f);
}
