package dev.eblanvisuals.mixin;

import dev.eblanvisuals.modules.impl.render.TimeChanger;
import dev.eblanvisuals.EblanVisuals;
import net.minecraft.client.world.ClientWorld;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(ClientWorld.Properties.class)
public abstract class ClientWorldPropertiesMixin  {

    @Shadow private long timeOfDay;

    @Inject(method = "setTimeOfDay", at = @At("HEAD"), cancellable = true)
    public void setTimeOfDayHook(long timeOfDay, CallbackInfo ci) {
        TimeChanger tweaks = EblanVisuals.getInstance().getModuleManager().getModule(TimeChanger.class);
        if (tweaks.isToggled()) {
            this.timeOfDay = (long) (tweaks.Time.getValue() * 1000L);
            ci.cancel();
        }
    }
}