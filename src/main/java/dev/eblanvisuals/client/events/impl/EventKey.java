package dev.eblanvisuals.client.events.impl;

import dev.eblanvisuals.client.events.Event;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor @Getter
public class EventKey extends Event {
    private int key, action, modifiers;
}