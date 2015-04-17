//
//  Layout.swift
//  Cartography
//
//  Created by Robert Böhnke on 30/09/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import Foundation

/// Layouts a single view.
///
/// The views will have its layout updated after this call.
///
/// :param: view    The view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `view`.
///
public func layout(view: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: LayoutProxy -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view))

    oldConstraints.deactivate()
    context.constraints.activate()

    layoutIfNeeded(view)

    return context.constraints
}

/// Layouts two views.
///
/// The views will have their layout updated after this call.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func layout(view1: View, view2: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view1), LayoutProxy(context, view2))

    oldConstraints.deactivate()
    context.constraints.activate()

    layoutIfNeeded(view1, view2)

    return context.constraints
}

/// Layouts three views.
///
/// The views will have their layout updated after this call.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: view3   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func layout(view1: View, view2: View, view3: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view1), LayoutProxy(context, view2), LayoutProxy(context, view3))

    oldConstraints.deactivate()
    context.constraints.activate()

    layoutIfNeeded(view1, view2, view3)

    return context.constraints
}

/// Layouts an array of views.
///
/// The views will have their layout updated after this call.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func layout<C: CollectionType where C.Index: RandomAccessIndexType, C.Generator.Element == View>(views: C, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: LazyRandomAccessCollection<MapCollectionView<C, LayoutProxy>> -> ()) -> ConstraintGroup {
    let context = Context()
    function(lazy(views).map({ LayoutProxy(context, $0) }))

    oldConstraints.deactivate()
    context.constraints.activate()

    layoutIfNeeded(views)

    return context.constraints
}

/// Layouts a dictioary of views.
///
/// The views will have their layout updated after this call.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func layout<T: Hashable>(views: [T: View], replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: ([T : LayoutProxy] -> ())) -> ConstraintGroup {
    let context = Context()
    let proxies = map(views) { ($0, LayoutProxy(context, $1)) }
    function(Dictionary(proxies))

    oldConstraints.deactivate()
    context.constraints.activate()

    layoutIfNeeded(views.values)

    return context.constraints
}

/// Removes all constraints for a group.
///
/// The affected views will have their layout updated after this call.
///
/// :param: clear The `ConstraintGroup` whose constraints should be removed.
///
public func layout(clear oldConstraints: ConstraintGroup) {
    oldConstraints.deactivate(performLayout: true)
}

/// Updates the constraints of a single view.
///
/// :param: view    The view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `view`.
///
public func constrain(view: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: LayoutProxy -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view))

    oldConstraints.deactivate()
    context.constraints.activate()

    return context.constraints
}

/// Updates the constraints of two views.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func constrain(v1: View, v2: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, v1), LayoutProxy(context, v2))

    oldConstraints.deactivate()
    context.constraints.activate()

    return context.constraints
}

/// Updates the constraints of three views.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: view3   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func constrain(v1: View, v2: View, v3: View, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, v1), LayoutProxy(context, v2), LayoutProxy(context, v3))

    oldConstraints.deactivate()
    context.constraints.activate()

    return context.constraints
}

/// Updates the constraints of an array of views.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func constrain<C: CollectionType where C.Index: RandomAccessIndexType, C.Generator.Element == View>(views: C, replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: LazyRandomAccessCollection<MapCollectionView<C, LayoutProxy>> -> ()) -> ConstraintGroup {
    let context = Context()
    function(lazy(views).map({ LayoutProxy(context, $0) }))

    oldConstraints.deactivate()
    context.constraints.activate()

    return context.constraints
}

/// Updates the constraints of a dictionary of views.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func constrain<T: Hashable>(views: [T: View], replace oldConstraints: ConstraintGroup = ConstraintGroup(), @noescape function: ([T : LayoutProxy] -> ())) -> ConstraintGroup {
    let context = Context()
    let proxies = map(views) { ($0, LayoutProxy(context, $1)) }
    function(Dictionary(proxies))

    oldConstraints.deactivate()
    context.constraints.activate()

    return context.constraints
}

/// Removes all constraints for a group.
///
/// :param: clear The `ConstraintGroup` whose constraints should be removed.
///
public func constrain(clear oldConstraints: ConstraintGroup) {
    oldConstraints.deactivate()
}
