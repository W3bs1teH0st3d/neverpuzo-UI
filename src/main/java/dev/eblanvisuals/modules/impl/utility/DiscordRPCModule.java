package dev.eblanvisuals.modules.impl.utility;

import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.util.DiscordRichPresenceUtil;
import net.minecraft.client.resource.language.I18n;

public class DiscordRPCModule extends Module {
    public DiscordRPCModule() {
        super("DiscordRPC", Category.Utility, I18n.translate("module.discordrpc.description"));
    }

    @Override
    public void onEnable() {
        super.onEnable();
        DiscordRichPresenceUtil.discordrpc();
    }

    @Override
    public void onDisable() {
        super.onDisable();
        DiscordRichPresenceUtil.shutdownDiscord();
    }
}
