//
//  ViewUtils.swift
//  Cartography
//
//  Created by Garth Snyder on 11/23/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

internal func layoutIfNeeded<Seq: SequenceType where Seq.Generator.Element == View>(views: Seq) {
    for view in views {
        #if os(iOS)
        view.layoutIfNeeded()
        #else
        view.layoutSubtreeIfNeeded()
        #endif
    }
}

internal func layoutIfNeeded(views: View...) {
    layoutIfNeeded(views)
}

internal func closestCommonAncestor(a: View, b: View) -> View? {
    let (aSuper, bSuper) = (a.superview, b.superview)

    if a === b { return a }

    if a === bSuper { return a }

    if b === aSuper { return b }

    if aSuper === bSuper { return aSuper }

    var ancestorsOfA = Set(ancestors(a))

    for ancestor in ancestors(b) {
        if ancestorsOfA.contains(ancestor) {
            return ancestor
        }
    }

    return .None
}

private func ancestors(v: View) -> SequenceOf<View> {
    return SequenceOf<View> { () -> GeneratorOf<View> in
        var view: View? = v
        return GeneratorOf {
            let current = view
            view = view?.superview
            return current
        }
    }
}
