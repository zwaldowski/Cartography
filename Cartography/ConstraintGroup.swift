//
//  ConstraintGroup.swift
//  Cartography
//
//  Created by Robert Böhnke on 22/01/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//

import Foundation

public struct ConstraintGroup {

    private static let supportsModernStorage: Bool = {
        NSLayoutConstraint.instancesRespondToSelector("isActive")
    }()

    private enum Storage {
        case Modern([NSLayoutConstraint])
        case Legacy([Constraint])
    }

    private var storage: Storage

    public init() {
        if ConstraintGroup.supportsModernStorage {
            self.storage = .Modern([])
        } else {
            self.storage = .Legacy([])
        }
    }

    public var isActive: Bool {
        switch storage {
        case .Modern(let constraints):
            return reduce(lazy(constraints).map({
                $0.active
            }), true) {
                $0 && $1
            }
        case .Legacy(let constraints):
            for constraint in constraints {
                let theseConstraints = constraint.view?.car_constraints ?? []
                if !contains(theseConstraints, {
                    $0 === constraint.layoutConstraint
                }) { return false }
            }
            return true
        }
    }

    private func setActive(newValue: Bool, performLayout: Bool = false) {
        switch storage {
        case .Modern(let constraints):
            if newValue {
                NSLayoutConstraint.activateConstraints(constraints)
            } else {
                NSLayoutConstraint.deactivateConstraints(constraints)
            }

            if performLayout {
                layoutIfNeeded(lazy(constraints).map({
                    closestCommonAncestor($0.firstItem as? View, $0.secondItem as? View)
                }).filter({
                    $0 != nil
                }).map(unsafeUnwrap))
            }
        case .Legacy(let constraints):
            for constraint in constraints {
                constraint.uninstall()
                if performLayout, let view = constraint.view {
                    layoutIfNeeded(view)
                }
            }
        }

    }

    public func activate(performLayout: Bool = false) {
        setActive(true, performLayout: performLayout)
    }

    public func deactivate(performLayout: Bool = false) {
        setActive(false, performLayout: performLayout)
    }

}

// MARK: SequenceType

extension ConstraintGroup: SequenceType {

    public func generate() -> GeneratorOf<NSLayoutConstraint> {
        switch storage {
        case .Legacy(let constraints):
            return GeneratorOf(lazy(constraints).map({ $0.layoutConstraint }).generate())
        case .Modern(let constraints):
            return GeneratorOf(constraints.generate())
        }
    }

}

// MARK: CollectionType

extension ConstraintGroup: CollectionType {

    public var startIndex: Int {
        switch storage {
        case .Legacy(let constraints):
            return constraints.startIndex
        case .Modern(let constraints):
            return constraints.startIndex
        }
    }

    public var endIndex: Int {
        switch storage {
        case .Legacy(let constraints):
            return constraints.endIndex
        case .Modern(let constraints):
            return constraints.endIndex
        }
    }

    public subscript (position: Int) -> NSLayoutConstraint {
        switch storage {
        case .Legacy(let constraints):
            return constraints[position].layoutConstraint
        case .Modern(let constraints):
            return constraints[position]
        }
    }

}

// MARK: ExtensibleCollectionType

extension ConstraintGroup: ExtensibleCollectionType {

    public mutating func append(c: NSLayoutConstraint) {
        switch (storage, c.secondItem) {
        case (.Modern(var constraints), _):
            constraints.append(c)
            storage = .Modern(constraints)
        case (.Legacy(var constraints), .Some(let to as View)):
            if let common = closestCommonAncestor(c.firstItem as? View, to) {
                constraints.append(Constraint(view: common, layoutConstraint: c))
                storage = .Legacy(constraints)
            } else {
                fatalError("No common superview found between \(c.firstItem) and \(to)")
            }
        case (.Legacy(var constraints), _):
            constraints.append(Constraint(view: c.firstItem as! View, layoutConstraint: c))
            storage = .Legacy(constraints)
        }
    }

    public mutating func reserveCapacity(n: Int) {
        switch storage {
        case .Modern(var constraints):
            constraints.reserveCapacity(n)
            storage = .Modern(constraints)
        case .Legacy(var constraints):
            constraints.reserveCapacity(n)
            storage = .Legacy(constraints)
        }
    }

    public mutating func extend<Seq: SequenceType where Seq.Generator.Element == NSLayoutConstraint>(newElements: Seq) {
        switch storage {
        case .Modern(var constraints):
            constraints.extend(newElements)
            storage = .Modern(constraints)
        case .Legacy(var constraints):
            constraints.reserveCapacity(count(self) + underestimateCount(newElements))
            for x in newElements {
                self.append(x)
            }
            storage = .Legacy(constraints)
        }
    }

}
