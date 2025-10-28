package dev.eblanvisuals.mixin;

import com.mojang.authlib.GameProfile;
import dev.eblanvisuals.client.managers.ModuleManager;
import dev.eblanvisuals.modules.impl.utility.Cape;
import net.minecraft.client.network.PlayerListEntry;
import net.minecraft.client.util.SkinTextures;
import net.minecraft.util.Identifier;
import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;
import dev.eblanvisuals.EblanVisuals;

@Mixin(value = PlayerListEntry.class, priority = 2000)
public class MixinCapeFeatureRenderer {

    private static final Identifier CUSTOM_CAPE = Identifier.of("simplevisuals", "textures/newcape.png");

    @Shadow @Final private GameProfile profile;

    @Inject(method = "getSkinTextures", at = @At("RETURN"), cancellable = true)
    public void onGetSkinTextures(CallbackInfoReturnable<SkinTextures> cir) {
        if (EblanVisuals.getInstance().getModuleManager().getModule(Cape.class).isToggled()) {
        SkinTextures original = cir.getReturnValue();
        cir.setReturnValue(new SkinTextures(
                original.texture(),
                original.textureUrl(),
                CUSTOM_CAPE,
                original.elytraTexture(),
                original.model(),
                original.secure()
        ));
    }
    }
}

