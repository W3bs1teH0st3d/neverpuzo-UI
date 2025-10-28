package dev.eblanvisuals.modules.impl.render;

import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.NumberSetting;
import net.minecraft.client.resource.language.I18n;

public class ItemPhysic extends Module {
    public ItemPhysic() {
        super("ItemPhysic", Category.Render, I18n.translate("module.itemphysic.description"));
    }
}
