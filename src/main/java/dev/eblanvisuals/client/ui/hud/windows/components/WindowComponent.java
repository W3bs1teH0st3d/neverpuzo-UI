package dev.eblanvisuals.client.ui.hud.windows.components;

import dev.eblanvisuals.client.ui.hud.windows.components.impl.BooleanComponent;
import dev.eblanvisuals.client.ui.clickgui.components.Component;
import dev.eblanvisuals.client.util.animations.Animation;
import lombok.*;

@Getter @Setter
public abstract class WindowComponent extends Component {
	protected Animation animation;

	public WindowComponent(String name) {
		super(name);
	}
}