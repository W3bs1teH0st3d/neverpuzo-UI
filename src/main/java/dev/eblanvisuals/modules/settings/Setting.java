package dev.eblanvisuals.modules.settings;

import dev.eblanvisuals.EblanVisuals;
import dev.eblanvisuals.client.events.impl.EventSettingChange;
import lombok.*;

import java.util.function.Supplier;

@Getter @Setter
public abstract class Setting<Value> {

    private final String name;
    protected Value value, defaultValue;
    private Supplier<Boolean> visible = () -> true;

    public Setting(String name, Value defaultValue) {
        this.name = name;
        this.defaultValue = defaultValue;
        this.value = defaultValue;
    }

    public Setting(String name, Value defaultValue, Supplier<Boolean> visible) {
        this.name = name;
        this.defaultValue = defaultValue;
        this.value = defaultValue;
        this.visible = visible;
    }

    public void setValue(Value value) {
        EventSettingChange event = new EventSettingChange(this);
        EblanVisuals.getInstance().getEventHandler().post(event);
        if (!event.isCancelled()) {
            this.value = value;
            // Планируем автосохранение после успешного применения
            try {
                dev.eblanvisuals.client.managers.AutoSaveManager asm = EblanVisuals.getInstance().getAutoSaveManager();
                if (asm != null) asm.scheduleAutoSave();
            } catch (Throwable ignored) {}
        }
    }

    public void reset() {
        this.value = defaultValue;
    }

    public boolean isVisible() {
        return visible.get();
    }
}