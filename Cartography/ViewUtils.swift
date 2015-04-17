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

internal func closestCommonAncestor(a: View?, b: View?) -> View? {
    switch (a, b) {
    case (.None, _):
        return b
    case (_, .None):
        return a
    case (.Some(let a), .Some(let b)) where a === b:
        return a
    case (.Some(let a), .Some(let b)):
        let (aSuper, bSuper) = (a.superview, b.superview)
        if a === bSuper { return a }
        if b === aSuper { return b }
        if aSuper === bSuper { return aSuper }

        for lAncestor in ancestors(a) {
            for rAncestor in ancestors(b) {
                if lAncestor === rAncestor { return rAncestor }
            }
        }
    default: break
    }

    return nil
}

private struct ViewAncestorsGenerator: GeneratorType {

    var view: View?

    mutating func next() -> View? {
        let current = view
        view = view?.superview
        return current
    }

}

private struct ViewAncestorsSequence: SequenceType {

    let view: View

    private func generate() -> ViewAncestorsGenerator {
        return ViewAncestorsGenerator(view: view)
    }

}

private func ancestors(v: View) -> ViewAncestorsSequence {
    return ViewAncestorsSequence(view: v)
}
