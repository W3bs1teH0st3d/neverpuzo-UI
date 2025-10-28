package dev.eblanvisuals.modules.impl.utility;

import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.BooleanSetting;
import dev.eblanvisuals.modules.settings.impl.ListSetting;
import net.minecraft.client.resource.language.I18n;

public class Cape extends Module {

    public Cape() {
        super("Cape", Category.Utility, I18n.translate("module.cape.description"));
    }

}
