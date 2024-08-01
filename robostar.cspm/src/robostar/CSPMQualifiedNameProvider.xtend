/********************************************************************************
 * Copyright (c) 2024 University of York and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Pedro Ribeiro - initial definition
 ********************************************************************************/
package robostar

import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.emf.ecore.EObject
import robostar.cspm.Constructor
import org.eclipse.xtext.naming.QualifiedName

class CSPMQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider {
	
//	def protected qualifiedName(Constructor obj) {
//		val container = obj.eContainer
//		if (container !== null) {
//			val superContainer = container.eContainer
//			val superQualified = super.qualifiedName(superContainer)
//			if (superQualified !== null)
//				return superQualified.append(obj.name)
//			else 
//				return QualifiedName.create(obj.name)
//		} else {
//			super.qualifiedName(obj)
//		}
//	}

//	def computeFullyQualifiedName(Constructor obj) {
//		return null;
//	}
	
	override protected computeFullyQualifiedNameFromNameAttribute(EObject obj) {
		if (obj instanceof Constructor) {
			val container = obj.eContainer
			if (container !== null) {
				val computed = super.computeFullyQualifiedNameFromNameAttribute(container.eContainer)
				if (computed !== null) {
					return computed.append(obj.name)
				} else {
					return QualifiedName.create(obj.name)
				}
			} else {
				super.computeFullyQualifiedNameFromNameAttribute(obj)
			}
		} else {
			super.computeFullyQualifiedNameFromNameAttribute(obj)
		}
	}
	
}