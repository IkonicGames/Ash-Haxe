package ash.fsm;

import ash.core.System;
import ash.fsm.DynamicSystemProvider.DynamicSystemProviderClosure;

/**
 * Represents a state for a SystemStateMachine. The state contains any number of SystemProviders which
 * are used to add Systems to the Engine when this state is entered.
 */
class EngineState
{
    public var providers(default, null):Array<ISystemProvider<System>>;

    public function new()
    {
        providers = [];
    }

    /**
     * Creates a mapping for the System type to a specific System instance. A
     * SystemInstanceProvider is used for the mapping.
     *
     * @param system The System instance to use for the mapping
     * @return This StateSystemMapping, so more modifications can be applied
     */

    public inline function addInstance<T:System>(system:T, priority:Int = 0):StateSystemMapping<T>
    {
        return addProvider(new SystemInstanceProvider( system, priority ));
    }

    /**
     * Creates a mapping for the System type to a single instance of the provided type.
     * The instance is not created until it is first requested. The type should be the same
     * as or extend the type for this mapping. A SystemSingletonProvider is used for
     * the mapping.
     *
     * @param type The type of the single instance to be created. If omitted, the type of the
     * mapping is used.
     * @return This StateSystemMapping, so more modifications can be applied
     */

    public function addSingleton<T:System>(type:Class<T>, priority:Int = 0):StateSystemMapping<T>
    {
        return addProvider(new SystemSingletonProvider( type, priority ));
    }

    /**
     * Creates a mapping for the System type to a method call.
     * The method should return a System instance. A DynamicSystemProvider is used for
     * the mapping.
     *
     * @param method The method to provide the System instance.
     * @return This StateSystemMapping, so more modifications can be applied.
     */

    public function addMethod<T:System>(method:DynamicSystemProviderClosure<T>, priority:Int = 0):StateSystemMapping<T>
    {
        return addProvider(new DynamicSystemProvider( method, priority ));
    }

    /**
     * Adds any SystemProvider.
     *
     * @param provider The component provider to use.
     * @return This StateSystemMapping, so more modifications can be applied.
     */

    public function addProvider<T:System>(provider:ISystemProvider<T>):StateSystemMapping<T>
    {
        var mapping:StateSystemMapping<T> = new StateSystemMapping( this, provider );
        providers.push(cast provider);
        return mapping;
    }
}
