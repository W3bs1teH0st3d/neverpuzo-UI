package dev.eblanvisuals.client.util.renderer.fonts;

import dev.eblanvisuals.client.render.msdf.MsdfFont;

public record Instance(MsdfFont font, float size) {
    public float getWidth(String text) {
        return font.getWidth(text, size);
    }

    public float getHeight() {
        return font.getHeight(size);
    }

}