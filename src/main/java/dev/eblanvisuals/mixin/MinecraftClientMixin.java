package dev.eblanvisuals.mixin;

import dev.eblanvisuals.EblanVisuals;
import dev.eblanvisuals.client.events.impl.EventTick;
import dev.eblanvisuals.client.events.impl.EventGameShutdown;
import dev.eblanvisuals.client.util.math.Counter;
import dev.eblanvisuals.client.managers.HitDetectionManager;
import dev.eblanvisuals.client.util.Wrapper;
import net.minecraft.client.MinecraftClient;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(MinecraftClient.class)
public abstract class MinecraftClientMixin implements Wrapper {
    
    private static int tickCounter = 0;

    @Inject(method = "tick", at = @At("HEAD"))
    public void tick(CallbackInfo ci) {
        EventTick event = new EventTick();
        EblanVisuals.getInstance().getEventHandler().post(event);
        Counter.updateFPS();
        
        // Периодическая очистка HitDetectionManager (каждые 20 тиков = 1 секунда)
        tickCounter++;
        if (tickCounter >= 20) {
            HitDetectionManager.getInstance().cleanup();
            tickCounter = 0;
        }
    }

    @Inject(method = "getWindowTitle", at = @At("HEAD"), cancellable = true)
    public void updateWindowTitle(CallbackInfoReturnable<String> cir) {
        cir.setReturnValue("SimpleVisuals 0.4(BETA)");
    }

    @Inject(method = "stop", at = @At("HEAD"))
    private void onStop(CallbackInfo ci) {
        // Публикуем событие выключения игры для автосохранения конфигурации
        EblanVisuals.getInstance().getEventHandler().post(new EventGameShutdown());
    }
}