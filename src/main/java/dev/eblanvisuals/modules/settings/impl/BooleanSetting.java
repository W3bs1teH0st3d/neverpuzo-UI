package dev.eblanvisuals.modules.settings.impl;

import dev.eblanvisuals.modules.settings.Setting;

import java.util.function.Supplier;

public class BooleanSetting extends Setting<Boolean> {

    public BooleanSetting(String name, Boolean defaultValue, Supplier<Boolean> visible) {
        super(name, defaultValue, visible);
    }

    public BooleanSetting(String name, Boolean defaultValue) {
        super(name, defaultValue);
    }
}