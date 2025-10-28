package dev.eblanvisuals.modules.impl.render;

import dev.eblanvisuals.client.util.animations.Animation;
import dev.eblanvisuals.client.util.animations.Easing;
import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.settings.impl.BooleanSetting;
import lombok.Getter;
import lombok.Setter;
import net.minecraft.client.resource.language.I18n;

public class BetterMinecraft extends Module {
	public final BooleanSetting smoothTab = new BooleanSetting("setting.smoothTab", true);
	public final BooleanSetting smoothThirdPersonZoom = new BooleanSetting("setting.smoothThirdPersonZoom", true);

	@Getter private final Animation tabOpenAnimation = new Animation(250, 1.0, false, Easing.BOTH_SINE);
	@Getter private final Animation thirdPersonAnimation = new Animation(300, 1.0, false, Easing.BOTH_SINE);

	@Getter @Setter private boolean tabPressed = false;

	public BetterMinecraft() {
		super("BetterMinecraft", Category.Render, I18n.translate("module.betterminecraft.description"));
	}
} 