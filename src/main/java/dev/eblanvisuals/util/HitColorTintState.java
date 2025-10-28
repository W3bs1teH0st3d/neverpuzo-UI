package dev.eblanvisuals.util;

public final class HitColorTintState {
    private HitColorTintState() {}
    public static final ThreadLocal<Boolean> SHOULD_TINT = ThreadLocal.withInitial(() -> false);
}


