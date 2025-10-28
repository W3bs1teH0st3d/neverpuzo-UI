package dev.eblanvisuals.client.events.impl;

import dev.eblanvisuals.client.events.Event;
import dev.eblanvisuals.client.managers.ThemeManager;

public class EventThemeChanged extends Event {
    private final ThemeManager.Theme theme;
    
    public EventThemeChanged(ThemeManager.Theme theme) {
        this.theme = theme;
    }
    
    public ThemeManager.Theme getTheme() {
        return theme;
    }
} 