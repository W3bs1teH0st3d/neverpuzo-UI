package dev.eblanvisuals.client.events.impl;

import dev.eblanvisuals.client.events.Event;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor @Getter
public class EventMouse extends Event {
    private int button, action;
}