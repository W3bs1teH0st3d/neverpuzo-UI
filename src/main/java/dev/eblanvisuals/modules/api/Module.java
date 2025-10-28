package dev.eblanvisuals.modules.api;

import dev.eblanvisuals.EblanVisuals;
import dev.eblanvisuals.modules.settings.Setting;
import dev.eblanvisuals.modules.settings.api.Bind;
import dev.eblanvisuals.client.util.Wrapper;
import dev.eblanvisuals.client.util.notify.Notify;
import dev.eblanvisuals.client.util.notify.NotifyIcons;
import lombok.Getter;
import lombok.Setter;
import net.minecraft.client.resource.language.I18n;

import java.util.ArrayList;
import java.util.List;

@Getter
public abstract class Module implements Wrapper {
    private final String name, description;
    private final Category category;
    protected boolean toggled;
    @Setter private Bind bind = new Bind(-1, false);
    private final List<Setting<?>> settings = new ArrayList<>();

    public Module(String name, Category category, String description) {
        this.name = name;
        this.category = category;
        this.description = description;
    }

    // Temporary backward compatibility; prefer using the 3-arg ctor with explicit description
    public Module(String name, Category category) {
        this(name, category, name);
    }

    public void onEnable() {
        toggled = true;
        EblanVisuals.getInstance().getEventHandler().subscribe(this);
        if (!fullNullCheck() && !name.equals("UI")) {
            String translatedName = I18n.translate(name);
            String msg = I18n.translate("notify.featureEnabled", translatedName);
            EblanVisuals.getInstance().getNotifyManager().add(new Notify(NotifyIcons.successIcon, msg, 1000));
        }
    }

    public void onDisable() {
        toggled = false;
        EblanVisuals.getInstance().getEventHandler().unsubscribe(this);
        if (!fullNullCheck() && !name.equals("UI")) {
            String translatedName = I18n.translate(name);
            String msg = I18n.translate("notify.featureDisabled", translatedName);
            EblanVisuals.getInstance().getNotifyManager().add(new Notify(NotifyIcons.failIcon, msg, 1000));
        }
    }

    public void setToggled(boolean toggled) {
        if (toggled) onEnable();
        else onDisable();
        // Планируем автосохранение после изменения состояния модуля
        try {
            dev.eblanvisuals.client.managers.AutoSaveManager asm = EblanVisuals.getInstance().getAutoSaveManager();
            if (asm != null) asm.scheduleAutoSave();
        } catch (Throwable ignored) {}
    }

    public void toggle() {
        setToggled(!toggled);
    }

    public static boolean fullNullCheck() {
        return mc.player == null || mc.world == null;
    }
}