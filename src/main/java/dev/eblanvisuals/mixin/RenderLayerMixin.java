package dev.eblanvisuals.mixin;

import dev.eblanvisuals.modules.impl.render.HitColor;
import dev.eblanvisuals.EblanVisuals;
import dev.eblanvisuals.util.HitColorTintState;
import net.minecraft.client.render.RenderLayer;
import net.minecraft.util.Identifier;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Redirect;

@Mixin(RenderLayer.class)
public abstract class RenderLayerMixin {

    private static final Identifier SV_WHITE = Identifier.of("minecraft", "textures/misc/white.png");

    @Redirect(method = "*",
            at = @At(value = "INVOKE", target = "Lnet/minecraft/client/render/RenderLayer;getArmorCutoutNoCull(Lnet/minecraft/util/Identifier;)Lnet/minecraft/client/render/RenderLayer;"))
    private static RenderLayer simplevisuals$globalArmorLayer(Identifier texture) {
        HitColor module = EblanVisuals.getInstance().getModuleManager().getModule(HitColor.class);
        if (module != null && module.isToggled() && Boolean.TRUE.equals(HitColorTintState.SHOULD_TINT.get())) {
            return RenderLayer.getEntityTranslucent(SV_WHITE);
        }
        return RenderLayer.getArmorCutoutNoCull(texture);
    }
}


