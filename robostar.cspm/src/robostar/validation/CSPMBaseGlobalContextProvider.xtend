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

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IResourceDescriptions
import org.eclipse.xtext.validation.DefaultUniqueNameContext.Global
import robostar.CSPMGlobalScopeProvider

/**
 * This class provides a DefaultUniqueNameContext.GlobalContextProvider that knows how to handle importedURIs
 * from CSPM resources. It therefore allows checking for uniqueness taking into account imported resources.
 * For this we reuse the CSPMGlobalScopeProvider that knows how to calculate ResourceDescriptions taking into
 * account importedURIs.
 */
class CSPMBaseGlobalContextProvider extends Global {
	
	@Inject
	CSPMGlobalScopeProvider cspScopeProvider;
	
	override IResourceDescriptions getIndex(Resource resource) {
		var importedURIs = cspScopeProvider.getImportedUris(resource)
		return cspScopeProvider.getResourceDescriptions(resource, importedURIs)
	}
	
}