package dev.eblanvisuals.client.events.impl;

import dev.eblanvisuals.client.events.Event;
import dev.eblanvisuals.modules.settings.Setting;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor @Getter
public class EventSettingChange extends Event {
    private final Setting<?> setting;
}