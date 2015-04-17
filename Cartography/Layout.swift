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
public func layout(view: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: LayoutProxy -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view))
    group.replaceConstraints(context.constraints)
    layoutIfNeeded(view)

    return group
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
public func layout(view1: View, view2: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view1), LayoutProxy(context, view2))
    group.replaceConstraints(context.constraints)
    layoutIfNeeded(view1, view2)

    return group
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
public func layout(view1: View, view2: View, view3: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view1), LayoutProxy(context, view2), LayoutProxy(context, view3))
    group.replaceConstraints(context.constraints)
    layoutIfNeeded(view1, view2, view3)

    return group
}

/// Layouts an array of views.
///
/// The views will have their layout updated after this call.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func layout<C: CollectionType where C.Index: RandomAccessIndexType, C.Generator.Element == View>(views: C, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: LazyRandomAccessCollection<MapCollectionView<C, LayoutProxy>> -> ()) -> ConstraintGroup {
    let context = Context()
    function(lazy(views).map({ LayoutProxy(context, $0) }))
    group.replaceConstraints(context.constraints)
    layoutIfNeeded(views)

    return group
}

/// Layouts a dictioary of views.
///
/// The views will have their layout updated after this call.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func layout<T: Hashable>(views: [T: View], var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: ([T : LayoutProxy] -> ())) -> ConstraintGroup {
    let context = Context()
    let proxies = map(views) { ($0, LayoutProxy(context, $1)) }
    function(Dictionary(proxies))
    group.replaceConstraints(context.constraints)
    layoutIfNeeded(views.values)

    return group
}

/// Removes all constraints for a group.
///
/// The affected views will have their layout updated after this call.
///
/// :param: clear The `ConstraintGroup` whose constraints should be removed.
///
public func layout(var clear group: ConstraintGroup) {
    group.replaceConstraints([], performLayout: true)
}

/// Updates the constraints of a single view.
///
/// :param: view    The view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `view`.
///
public func constrain(view: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: LayoutProxy -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, view))
    group.replaceConstraints(context.constraints)

    return group
}

/// Updates the constraints of two views.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func constrain(v1: View, v2: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, v1), LayoutProxy(context, v2))
    group.replaceConstraints(context.constraints)

    return group
}

/// Updates the constraints of three views.
///
/// :param: view1   A view to layout.
/// :param: view2   A view to layout.
/// :param: view3   A view to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for the views.
///
public func constrain(v1: View, v2: View, v3: View, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: (LayoutProxy, LayoutProxy, LayoutProxy) -> ()) -> ConstraintGroup {
    let context = Context()
    function(LayoutProxy(context, v1), LayoutProxy(context, v2), LayoutProxy(context, v3))
    group.replaceConstraints(context.constraints)

    return group
}

/// Updates the constraints of an array of views.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func constrain<C: CollectionType where C.Index: RandomAccessIndexType, C.Generator.Element == View>(views: C, var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: LazyRandomAccessCollection<MapCollectionView<C, LayoutProxy>> -> ()) -> ConstraintGroup {
    let context = Context()
    function(lazy(views).map({ LayoutProxy(context, $0) }))
    group.replaceConstraints(context.constraints)

    return group
}

/// Updates the constraints of a dictionary of views.
///
/// :param: views   The views to layout.
/// :param: replace The `ConstraintGroup` whose constraints should be replaced.
/// :param: block   A block that declares the layout for `views`.
///
public func constrain<T: Hashable>(views: [T: View], var replace group: ConstraintGroup = ConstraintGroup(), @noescape function: ([T : LayoutProxy] -> ())) -> ConstraintGroup {
    let context = Context()
    let proxies = map(views) { ($0, LayoutProxy(context, $1)) }
    function(Dictionary(proxies))
    group.replaceConstraints(context.constraints)

    return group
}

/// Removes all constraints for a group.
///
/// :param: clear The `ConstraintGroup` whose constraints should be removed.
///
public func constrain(var clear group: ConstraintGroup) {
    group.replaceConstraints([])
}
