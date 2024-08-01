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
package robostar.validation

import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.validation.NamesAreUniqueValidationHelper
import org.eclipse.xtext.validation.ValidationMessageAcceptor
import robostar.cspm.CSPM
import robostar.cspm.CspmPackage
import robostar.cspm.Function
import robostar.cspm.LetExp
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EObject
import com.google.common.base.Preconditions
import java.util.Collection

class CSPMNamesAreUniqueValidationHelper extends NamesAreUniqueValidationHelper {
	
//	INamesAreUniqueValidationHelper.ContextProvider thisContextProvider = new DefaultUniqueNameContext.ExportedFromResource;
//	
//	new() {
//		super()
//		this. setContextProvider(thisContextProvider)
//	}
	
	override checkUniqueNames(Context context, ValidationMessageAcceptor acceptor) {
		super.doCheckUniqueNames(context, acceptor)
	}
	
	override protected getAssociatedClusterType(EClass eClass) {
		if (CspmPackage.eINSTANCE.pattern == eClass ||
			CspmPackage.eINSTANCE.variablePattern == eClass ||
			CspmPackage.eINSTANCE.typeVariable == eClass
		) return null
		super.getAssociatedClusterType(eClass)
	}
	
	override void doCheckUniqueIn(IEObjectDescription description, Context context,
			ValidationMessageAcceptor acceptor) {
		var object = description.getEObjectOrProxy();
		Preconditions.checkArgument(!object.eIsProxy());

		var clusterType = getClusterType(description);
		if (clusterType == null) {
			return;
		}
		var validationScope = context.getValidationScope(description, clusterType);
		if (validationScope.isEmpty()) {
			return;
		}
		var caseSensitive = context.isCaseSensitive(object, clusterType);
		var sameNames = validationScope.getExportedObjects(clusterType, description.getName(),
				!caseSensitive);
		if (sameNames instanceof Collection<?>) {
			if ((sameNames as Collection<?>).size() <= 1) {
				return;
			}
		}
		for (IEObjectDescription candidate : sameNames) {
			var otherObject = candidate.getEObjectOrProxy();
			if (object != otherObject && getAssociatedClusterType(candidate.getEClass()) == clusterType
					&& !otherObject.eIsProxy() || !candidate.getEObjectURI().equals(description.getEObjectURI())) {
				if (isDuplicate(description, candidate)) {
					createDuplicateNameError(description, candidate, clusterType, acceptor);
					return;
				}
			}
		}
	}
	
	def void createDuplicateNameError(IEObjectDescription description, IEObjectDescription candidate, EClass clusterType,
			ValidationMessageAcceptor acceptor) {
		var object = description.getEObjectOrProxy();
		var feature = getNameFeature(object);
		acceptor.acceptError(getDuplicateNameErrorMessage(description, candidate, clusterType, feature), object, feature,
				ValidationMessageAcceptor.INSIGNIFICANT_INDEX, getErrorCode());
	}
	
	def dispatch CSPM getCSPMPackage(CSPM cspm) {
		return cspm
	}
	
	def dispatch CSPM getCSPMPackage(EObject e) {
		if (e.eContainer !== null) {
			return getCSPMPackage(e.eContainer)
		} else {
			return null
		}
	}
	
	def String getDuplicateNameErrorMessage(IEObjectDescription description, IEObjectDescription candidate, EClass clusterType,
			EStructuralFeature feature) {
		var object = description.getEObjectOrProxy();
		var candidateObject = candidate.getEObjectOrProxy();
		var shortName = String.valueOf(feature !== null ? object.eGet(feature) : "<unnamed>");
		var result = new StringBuilder(64);
		
		result.append("Duplicate ");
		result.append(getTypeLabel(clusterType));
		result.append(" '");
		result.append(shortName);
		result.append("'");
		if (isContainerInformationHelpful(description, shortName)) {
			var container = getContainerForErrorMessage(object);
			if (container !== null) {
				var containerTypeLabel = getTypeLabel(container.eClass());
				var containerNameFeature = getNameFeature(container);
				if (isContainerInformationHelpful(description, container, containerTypeLabel, containerNameFeature)) {
					result.append(" in ");
					result.append(containerTypeLabel);
					if (containerNameFeature !== null) {
						var containerName = String.valueOf(container.eGet(containerNameFeature));
						if (containerName !== null) {
							result.append(" '");
							result.append(containerName);
							result.append("'");
						}
					}
				}
				
				var cspmDesc = getCSPMPackage(object)
				var cspmCandidate = getCSPMPackage(candidateObject)
				
				if (cspmDesc !== null && cspmCandidate !== null) {
					// Different packages
					if (cspmDesc != cspmCandidate) {
						result.append(" (already defined ")
						var candidateContainer = getContainerForErrorMessage(object);
						if (candidateContainer !== null) {
							var candidateContainerTypeLabel = getTypeLabel(candidateContainer.eClass());
							var candidateContainerNameFeature = getNameFeature(candidateContainer);
							if (isContainerInformationHelpful(candidate, candidateContainer, candidateContainerTypeLabel, candidateContainerNameFeature)) {
								result.append(" in ");
								result.append(candidateContainerTypeLabel);
								if (candidateContainerNameFeature !== null) {
									var containerName = String.valueOf(container.eGet(candidateContainerNameFeature));
									if (containerName !== null) {
										result.append(" '");
										result.append(containerName);
										result.append("' ");
									}
								}
							}
						}
						
						result.append("in file '")
						var uri = cspmCandidate.eResource.URI
						if (uri.platform) {
							result.append(uri.toPlatformString(true))
						} else {
							result.append(uri.toString())
						}
						result.append("')")
					}
				}
			}
		}
		return result.toString();
		
//		if (candidateContainer instanceof CSPM) {
//			var shortName = String.valueOf(feature != null ? object.eGet(feature) : "<unnamed>");
//			var result = new StringBuilder(64);
//			result.append("Duplicate ");
//			result.append(getTypeLabel(clusterType));
//			result.append(" '");
//			result.append(shortName);
//			result.append("'");
//			if (isContainerInformationHelpful(description, shortName)) {
//				if (container !== null) {
//					var containerTypeLabel = getTypeLabel(container.eClass());
//					if (containerTypeLabel != null) {
//						result.append(" in ");
//						result.append(containerTypeLabel);
//						
//						var uri = candidateContainer.eResource.URI
//						var String uriString
//						if (uri.platform) {
//							uriString = uri.toPlatformString(true)
//						} else {
//							uriString = uri.toString()
//						}
//						
//						if (uriString != null) {
//							result.append(" '");
//							result.append(uriString);
//							result.append("'");
//						}
//					}
//				}
//			}
//			return result.toString();
//		} else {
//			super.getDuplicateNameErrorMessage(description, clusterType, feature)
//		}
	}
	
	override protected isDuplicate(IEObjectDescription description, IEObjectDescription candidate) {
		
		val dobj = description.EObjectOrProxy
		val cobj = candidate.EObjectOrProxy
		if (dobj instanceof Function) {
			if (cobj instanceof Function) {
				val dcspm = dobj.eContainer
				val ccspm = cobj.eContainer 
				
				//if (dcspm == ccspm) {
					if (dcspm instanceof CSPM) {
						if (ccspm instanceof CSPM) {
							
							val dobjIndex = dcspm.definitions.indexOf(dobj)
							val cobjIndex = ccspm.definitions.indexOf(cobj)
							
							val min = dobjIndex <= cobjIndex ? dobjIndex : cobjIndex
							val max = dobjIndex > cobjIndex ? dobjIndex : cobjIndex
							
							try {
								return !dcspm.definitions.subList(min,max).forall[f|f instanceof Function && 
										((f as Function).name == dobj.name) && 
										((f as Function).args.size > 0) &&
										((f as Function).args.size == dobj.args.size)
								]
							} catch (Exception e) {
								return true
							}
						} else {
							return true
						}	
					} else if (dcspm instanceof LetExp) {
						if (ccspm instanceof LetExp) {
							val dobjIndex = dcspm.definitions.indexOf(dobj)
							val cobjIndex = ccspm.definitions.indexOf(cobj)
							
							val min = dobjIndex <= cobjIndex ? dobjIndex : cobjIndex
							val max = dobjIndex > cobjIndex ? dobjIndex : cobjIndex
							
							try {
								return !dcspm.definitions.subList(min,max).forall[f|f instanceof Function && 
										((f as Function).name == dobj.name) && 
										((f as Function).args.size > 0) &&
										((f as Function).args.size == dobj.args.size)
								]
							} catch (Exception e) {
								return true
							}
						} else {
							return true
						}
					}
				//}
			}
		}
		super.isDuplicate(description, candidate)
	}
	
}