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
package robostar.validation;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.INamesAreUniqueValidationHelper;
import org.eclipse.xtext.validation.NamesAreUniqueValidator;

import com.google.inject.Inject;

public class CSPNamesAreUniqueValidator extends NamesAreUniqueValidator {

	@Inject
	CSPMBaseGlobalContextProvider thisContextProvider = new CSPMBaseGlobalContextProvider();
	
	@Override
	protected INamesAreUniqueValidationHelper.Context getValidationContext(Resource resource, CancelIndicator cancelIndicator) {
		return thisContextProvider.tryGetContext(resource, cancelIndicator);
	}

}
