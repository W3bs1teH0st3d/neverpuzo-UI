package dev.eblanvisuals.modules.settings.impl;

import dev.eblanvisuals.modules.settings.Setting;
import dev.eblanvisuals.modules.settings.api.Position;

import java.util.function.Supplier;

public class PositionSetting extends Setting<Position> {

    public PositionSetting(String name, Position defaultValue) {
        super(name, defaultValue);
    }

    public PositionSetting(String name, Position defaultValue, Supplier<Boolean> visible) {
        super(name, defaultValue, visible);
    }
}