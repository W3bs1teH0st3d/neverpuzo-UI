package dev.eblanvisuals.client.util.notify;

import dev.eblanvisuals.client.events.impl.EventRender2D;
import dev.eblanvisuals.client.util.Wrapper;
import dev.eblanvisuals.client.util.animations.Animation;
import dev.eblanvisuals.client.util.animations.Easing;
import dev.eblanvisuals.client.util.math.TimerUtils;
import dev.eblanvisuals.client.util.renderer.fonts.Fonts;
import dev.eblanvisuals.client.util.renderer.Render2D;
import lombok.Getter;

import java.awt.*;

@Getter
public class Notify implements Wrapper {

    private final NotifyIcon icon;
    private final String notify;
    private final long delay;
    private float y;
    private final Animation animation = new Animation(300, 1f, true, Easing.BOTH_SINE);
    private final TimerUtils timer = new TimerUtils();

    public Notify(NotifyIcon icon, String notify, long delay) {
        this.icon = icon;
        this.notify = notify;
        this.delay = delay;
        y = mc.getWindow().getScaledHeight() / 2f + 10;
        timer.reset();
    }

    public void render(EventRender2D e, float picunY) {
        y = animate(y, picunY);
        float width = Fonts.MEDIUM.getWidth(notify, 9f);
        float width2 = Fonts.ICONS.getWidth(icon.icon(), 8f);
        float width3 = width + width2 + 7f;
        float x = mc.getWindow().getScaledWidth() / 2f - (width3 / 2f);
        if (timer.passed(delay)) animation.update(false);
        float animA = (float) animation.getValue();
        int bgA = (int) (175 * animA);
        int blurA = (int) (40 * animA);
        // Мягкий шейдерный blur-ореол позади + тёмная подложка сверху
        Render2D.drawShaderBlurRect(
                e.getContext().getMatrices(),
                x - 3.5f,
                y - 3.5f,
                width3 + 7f,
                17f,
                2f,
                8f,
                new Color(255, 255, 255, blurA)
        );
        Render2D.drawRoundedRect(
                e.getContext().getMatrices(),
                x - 2.5f,
                y - 2.5f,
                width3 + 5f,
                15f,
                1.5f,
                new Color(0, 0, 0, bgA)
        );
        Render2D.drawFont(e.getContext().getMatrices(), Fonts.MEDIUM.getFont(9f), notify, x + width2 + 4f, y - 0.5f, new Color(255, 255, 255, (int) (255 * animation.getValue())));
        Render2D.drawFont(e.getContext().getMatrices(), Fonts.ICONS.getFont(8f), icon.icon(), x + 1f, y + 1f, new Color(255, 255, 255, (int) (255 * animation.getValue())));
    }

    public float animate(float value, float target) {
        return value + (target - value) / 8f;
    }

    public boolean expired() {
        return timer.passed(delay) && animation.getValue() < 0.01f;
    }
}