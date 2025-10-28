package dev.eblanvisuals.client.ui.clickgui;

import dev.eblanvisuals.client.ui.clickgui.components.impl.ModuleComponent;
import dev.eblanvisuals.client.util.Wrapper;
import dev.eblanvisuals.client.util.animations.Animation;
import dev.eblanvisuals.client.util.animations.Easing;
import dev.eblanvisuals.client.util.renderer.Render2D;
import dev.eblanvisuals.client.util.renderer.fonts.Fonts;
import dev.eblanvisuals.client.managers.ThemeManager;
import dev.eblanvisuals.modules.api.Category;
import dev.eblanvisuals.modules.api.Module;
import dev.eblanvisuals.modules.impl.render.UI;
import dev.eblanvisuals.modules.impl.utility.ClientSound;
import dev.eblanvisuals.EblanVisuals;
import net.minecraft.client.gui.DrawContext;
import net.minecraft.client.gui.screen.Screen;
import net.minecraft.text.Text;
import net.minecraft.client.MinecraftClient;
import net.minecraft.sound.SoundEvent;
import net.minecraft.util.Identifier;
import net.minecraft.client.sound.PositionedSoundInstance;
import org.lwjgl.glfw.GLFW;

import java.awt.*;
import java.util.*;
import java.util.List;

/**
 * Neverlose-style ClickGUI for eblan Visuals
 */
public class NeverloseClickGui extends Screen implements Wrapper {

    // Neverlose color scheme
    private static final Color BG_DARK = new Color(17, 17, 22, 255);
    private static final Color BG_MEDIUM = new Color(22, 22, 28, 255);
    private static final Color BG_LIGHT = new Color(28, 28, 35, 255);
    private static final Color ACCENT = new Color(139, 158, 255, 255);
    private static final Color TEXT_PRIMARY = new Color(255, 255, 255, 255);
    private static final Color TEXT_SECONDARY = new Color(160, 160, 180, 255);
    private static final Color SEPARATOR = new Color(40, 40, 50, 255);

    private final Animation fadeAnimation = new Animation(250, 1f, true, Easing.OUT_QUAD);
    private final ThemeManager themeManager;

    private boolean closing = false;
    private float uiAlpha = 0f;

    private static final Category[] TABS = {
            Category.Render,
            Category.Utility,
            Category.Theme
    };

    private Category selectedCategory = Category.Render;

    private float x, y, width, height;
    private static final float SIDEBAR_WIDTH = 140f;
    private static final float HEADER_HEIGHT = 45f;
    private static final float PADDING = 12f;

    private final Map<Category, List<ModuleComponent>> componentsByCategory = new EnumMap<>(Category.class);

    private float scrollY = 0f;
    private float maxScroll = 0f;
    private float scrollYTarget = 0f;

    private static final int COLS = 2;
    private static final float GAP = 10f;

    private ModuleComponent activeSettings = null;
    private float settingsScrollY = 0f;
    private float settingsMaxScroll = 0f;
    private float settingsScrollYTarget = 0f;
    private final Animation settingsAnimation = new Animation(280, 1f, true, Easing.OUT_QUART);

    public NeverloseClickGui() {
        super(Text.of("eblan-visuals-gui"));
        this.themeManager = ThemeManager.getInstance();
    }

    @Override
    public void init() {
        super.init();
        this.width = 700f;
        this.height = 500f;
        this.x = (mc.getWindow().getScaledWidth() - this.width) / 2f;
        this.y = (mc.getWindow().getScaledHeight() - this.height) / 2f;

        buildComponentsCache();
        scrollY = 0f;
        scrollYTarget = 0f;

        closing = false;
        fadeAnimation.update(true);
    }

    private void buildComponentsCache() {
        componentsByCategory.clear();
        for (Category cat : TABS) {
            if (cat != Category.Theme) {
                List<Module> mods = EblanVisuals.getInstance().getModuleManager().getModules(cat);
                List<ModuleComponent> comps = new ArrayList<>(mods.size());
                for (Module m : mods) comps.add(new ModuleComponent(m));
                componentsByCategory.put(cat, comps);
            }
        }
    }

    private void playToggleSound(boolean wasToggled) {
        ClientSound clientSound = EblanVisuals.getInstance().getModuleManager().getModule(ClientSound.class);
        if (clientSound != null && clientSound.isToggled()) {
            String soundId = wasToggled ? clientSound.getDisableSoundId() : clientSound.getEnableSoundId();
            float volume = clientSound.getVolume().getValue();
            MinecraftClient.getInstance().getSoundManager().play(
                    PositionedSoundInstance.master(
                            SoundEvent.of(Identifier.of(soundId)),
                            1.0f,
                            volume
                    )
            );
        }
    }

    @Override
    public void close() {
        if (!closing) {
            closing = true;
            fadeAnimation.update(false);
        }
    }

    @Override
    public boolean shouldPause() {
        return false;
    }

    @Override
    public void render(DrawContext context, int mouseX, int mouseY, float delta) {
        if (closing) {
            fadeAnimation.update(false);
            if (fadeAnimation.getValue() <= 0.01f) {
                EblanVisuals.getInstance().getModuleManager().getModule(UI.class).setToggled(false);
                super.close();
                return;
            }
        } else {
            fadeAnimation.update(true);
        }

        uiAlpha = Math.max(0f, Math.min(1f, fadeAnimation.getValue()));

        int backdropAlpha = (int) (160 * uiAlpha);
        if (backdropAlpha > 0) {
            Render2D.drawRect(context.getMatrices(), 0f, 0f,
                    mc.getWindow().getScaledWidth(), mc.getWindow().getScaledHeight(),
                    new Color(0, 0, 0, backdropAlpha));
        }

        int alpha = (int) (255 * uiAlpha);

        Render2D.drawRoundedRect(context.getMatrices(), x, y, width, height, 6f,
                new Color(BG_DARK.getRed(), BG_DARK.getGreen(), BG_DARK.getBlue(), alpha));

        renderHeader(context, alpha);
        renderSidebar(context, mouseX, mouseY, alpha);
    }

    private void renderHeader(DrawContext ctx, int alpha) {
        Render2D.drawRoundedRect(ctx.getMatrices(), x, y, width, HEADER_HEIGHT, 6f,
                new Color(BG_MEDIUM.getRed(), BG_MEDIUM.getGreen(), BG_MEDIUM.getBlue(), alpha));

        String title = "NEVERLOSE";
        String subtitle = "eblan Visuals";
        
        float titleX = x + PADDING + 8f;
        float titleY = y + PADDING;

        Render2D.drawRoundedRect(ctx.getMatrices(), titleX - 2f, titleY - 2f, 28f, 28f, 4f,
                new Color(ACCENT.getRed(), ACCENT.getGreen(), ACCENT.getBlue(), alpha));
        
        Render2D.drawFont(ctx.getMatrices(), Fonts.BOLD.getFont(11f), "NL",
                titleX + 4f, titleY + 4f,
                new Color(TEXT_PRIMARY.getRed(), TEXT_PRIMARY.getGreen(), TEXT_PRIMARY.getBlue(), alpha));

        Render2D.drawFont(ctx.getMatrices(), Fonts.BOLD.getFont(13f), title,
                titleX + 35f, titleY + 2f,
                new Color(TEXT_PRIMARY.getRed(), TEXT_PRIMARY.getGreen(), TEXT_PRIMARY.getBlue(), alpha));

        Render2D.drawFont(ctx.getMatrices(), Fonts.REGULAR.getFont(8f), subtitle,
                titleX + 35f, titleY + 16f,
                new Color(TEXT_SECONDARY.getRed(), TEXT_SECONDARY.getGreen(), TEXT_SECONDARY.getBlue(), alpha));

        Render2D.drawRect(ctx.getMatrices(), x, y + HEADER_HEIGHT, width, 1f,
                new Color(SEPARATOR.getRed(), SEPARATOR.getGreen(), SEPARATOR.getBlue(), alpha));
    }

    private void renderSidebar(DrawContext ctx, int mouseX, int mouseY, int alpha) {
        float sidebarX = x;
        float sidebarY = y + HEADER_HEIGHT + 1f;
        float sidebarHeight = height - HEADER_HEIGHT - 1f;

        Render2D.drawRect(ctx.getMatrices(), sidebarX, sidebarY, SIDEBAR_WIDTH, sidebarHeight,
                new Color(BG_MEDIUM.getRed(), BG_MEDIUM.getGreen(), BG_MEDIUM.getBlue(), alpha));

        float tabY = sidebarY + PADDING;
        float tabHeight = 36f;
        float tabWidth = SIDEBAR_WIDTH - PADDING * 2;

        for (Category cat : TABS) {
            boolean active = cat == selectedCategory;
            boolean hovered = mouseX >= sidebarX + PADDING && mouseX <= sidebarX + PADDING + tabWidth &&
                    mouseY >= tabY && mouseY <= tabY + tabHeight;

            if (active) {
                Render2D.drawRoundedRect(ctx.getMatrices(), sidebarX + PADDING, tabY, tabWidth, tabHeight, 4f,
                        new Color(BG_LIGHT.getRed(), BG_LIGHT.getGreen(), BG_LIGHT.getBlue(), alpha));
                
                Render2D.drawRoundedRect(ctx.getMatrices(), sidebarX + PADDING, tabY, 3f, tabHeight, 1.5f,
                        new Color(ACCENT.getRed(), ACCENT.getGreen(), ACCENT.getBlue(), alpha));
            } else if (hovered) {
                Render2D.drawRoundedRect(ctx.getMatrices(), sidebarX + PADDING, tabY, tabWidth, tabHeight, 4f,
                        new Color(BG_LIGHT.getRed(), BG_LIGHT.getGreen(), BG_LIGHT.getBlue(), (int)(alpha * 0.5f)));
            }

            String catName = cat.name();
            String icon = ">";
            
            float iconX = sidebarX + PADDING + 12f;
            float textX = iconX + 20f;
            float centerY = tabY + (tabHeight - Fonts.MEDIUM.getHeight(9f)) / 2f;

            Render2D.drawFont(ctx.getMatrices(), Fonts.ICONS.getFont(12f), icon, iconX, centerY - 1f,
                    active ? new Color(ACCENT.getRed(), ACCENT.getGreen(), ACCENT.getBlue(), alpha) :
                            new Color(TEXT_SECONDARY.getRed(), TEXT_SECONDARY.getGreen(), TEXT_SECONDARY.getBlue(), alpha));

            Render2D.drawFont(ctx.getMatrices(), Fonts.MEDIUM.getFont(9f), catName, textX, centerY,
                    active ? new Color(TEXT_PRIMARY.getRed(), TEXT_PRIMARY.getGreen(), TEXT_PRIMARY.getBlue(), alpha) :
                            new Color(TEXT_SECONDARY.getRed(), TEXT_SECONDARY.getGreen(), TEXT_SECONDARY.getBlue(), alpha));

            tabY += tabHeight + 6f;
        }

        Render2D.drawRect(ctx.getMatrices(), sidebarX + SIDEBAR_WIDTH, sidebarY, 1f, sidebarHeight,
                new Color(SEPARATOR.getRed(), SEPARATOR.getGreen(), SEPARATOR.getBlue(), alpha));
    }

    @Override
    public boolean mouseClicked(double mouseX, double mouseY, int button) {
        if (closing) return false;

        float sidebarX = x;
        float sidebarY = y + HEADER_HEIGHT + 1f;
        float tabY = sidebarY + PADDING;
        float tabHeight = 36f;
        float tabWidth = SIDEBAR_WIDTH - PADDING * 2;

        for (Category cat : TABS) {
            if (mouseX >= sidebarX + PADDING && mouseX <= sidebarX + PADDING + tabWidth &&
                    mouseY >= tabY && mouseY <= tabY + tabHeight) {
                selectedCategory = cat;
                scrollY = 0f;
                scrollYTarget = 0f;
                activeSettings = null;
                return true;
            }
            tabY += tabHeight + 6f;
        }

        return super.mouseClicked(mouseX, mouseY, button);
    }

    @Override
    public boolean keyPressed(int keyCode, int scanCode, int modifiers) {
        if (closing) return false;

        if (keyCode == GLFW.GLFW_KEY_ESCAPE) {
            close();
            return true;
        }

        return super.keyPressed(keyCode, scanCode, modifiers);
    }

    private static float clamp(float v, float min, float max) {
        return Math.max(min, Math.min(max, v));
    }
}
