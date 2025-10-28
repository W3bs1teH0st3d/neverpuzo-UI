package dev.eblanvisuals;


import dev.eblanvisuals.client.managers.*;
import dev.eblanvisuals.client.ui.mainmenu.MainMenu;
import dev.eblanvisuals.client.util.Wrapper;
import meteordevelopment.orbit.EventBus;
import meteordevelopment.orbit.IEventBus;
import dev.eblanvisuals.client.ui.clickgui.ClickGui;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.minecraft.client.gui.screen.TitleScreen;
import net.minecraft.util.Identifier;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import lombok.*;

import java.io.File;
import java.lang.invoke.MethodHandles;

@Getter
public class EblanVisuals implements ModInitializer, Wrapper {

    @Getter private static EblanVisuals instance;

    private IEventBus eventHandler;
    private long initTime;
    private ModuleManager moduleManager;
    private CommandManager commandManager;
    private ConfigManager configManager;
    private AutoSaveManager autoSaveManager;
    private NotifyManager notifyManager;
    private PerformanceManager performanceManager;
    private ClickGui clickGui;
    private HudManager hudManager;
    private dev.eblanvisuals.client.managers.AltManager altManager;
    private MainMenu mainmenu;
    private dev.eblanvisuals.client.ui.hud.impl.WaypointOverlay waypointOverlay;

    public static Logger LOGGER = LogManager.getLogger(EblanVisuals.class);
    private final File globalsDir = new File(mc.runDirectory, "eblanvisuals");
    private final File configsDir = new File(globalsDir, "configs");

    @Override
    public void onInitialize() {
        LOGGER.info("[eblan Visuals] Starting initialization.");
        initTime = System.currentTimeMillis();
        instance = this;

        createDirs(globalsDir, configsDir);
        eventHandler = new EventBus();

        eventHandler.registerLambdaFactory("dev.eblanvisuals",
                (lookupInMethod, klass) -> (MethodHandles.Lookup) lookupInMethod.invoke(null, klass, MethodHandles.lookup())
        );

        FriendsManager.init(globalsDir);
        AltManager.init(globalsDir);
        String lastAlt = AltManager.getLastUsedNickname();
        if (lastAlt != null && !lastAlt.isEmpty()) {
            AltManager.applyNickname(lastAlt);
        }

        notifyManager = new NotifyManager();
        performanceManager = new PerformanceManager();
        moduleManager = new ModuleManager();
        commandManager = new CommandManager();
        configManager = new ConfigManager();
        autoSaveManager = new AutoSaveManager();
        clickGui = new ClickGui();
        hudManager = new HudManager();
        mainmenu = new MainMenu();

        // Always-on waypoint overlay
        waypointOverlay = new dev.eblanvisuals.client.ui.hud.impl.WaypointOverlay();
        eventHandler.subscribe(waypointOverlay);

        // Загружаем автоматически сохраненную конфигурацию
        // ВРЕМЕННО ОТКЛЮЧЕНО ДЛЯ ОТЛАДКИ
        //autoSaveManager.loadAutoSave();

        // Регистрация события для замены TitleScreen на MainMenu
        // ВРЕМЕННО ОТКЛЮЧЕНО ДЛЯ ОТЛАДКИ
        /*ClientTickEvents.END_CLIENT_TICK.register(client -> {
            if (client.currentScreen instanceof TitleScreen && !(client.currentScreen instanceof MainMenu)) {
                client.setScreen(mainmenu);
            }
        });*/

        LOGGER.info("[eblan Visuals] Successfully initialized for {} ms.", System.currentTimeMillis() - initTime);
    }

    private void createDirs(File... file) {
        for (File f : file) f.mkdirs();
    }

    public static Identifier id(String texture) {
        return Identifier.of("eblanvisuals", texture);
    }
}