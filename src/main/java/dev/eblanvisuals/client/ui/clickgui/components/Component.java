package dev.eblanvisuals.client.ui.clickgui.components;

import dev.eblanvisuals.client.util.Wrapper;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import net.minecraft.client.gui.DrawContext;

import java.util.function.Supplier;

@RequiredArgsConstructor @Getter @Setter
public abstract class Component implements Wrapper {
    private final String name;
    protected float x, y, width, height;
    protected Supplier<Float> addHeight = () -> 0f;
    protected Supplier<Boolean> visible = () -> true;
    protected float globalAlpha = 1f;

    public abstract void render(DrawContext context, int mouseX, int mouseY, float delta);
    public abstract void mouseClicked(double mouseX, double mouseY, int button);
    public abstract void mouseReleased(double mouseX, double mouseY, int button);
    public abstract void keyPressed(int keyCode, int scanCode, int modifiers);
    public abstract void keyReleased(int keyCode, int scanCode, int modifiers);
    public abstract void charTyped(char chr, int modifiers);
}