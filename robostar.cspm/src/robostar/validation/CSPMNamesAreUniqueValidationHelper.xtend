package robostar.validation

import org.eclipse.xtext.validation.NamesAreUniqueValidationHelper
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.resource.IEObjectDescription
import robostar.cspm.Function
import robostar.cspm.LetExp
import robostar.cspm.CSPM
import org.eclipse.xtext.validation.INamesAreUniqueValidationHelper.Context
import org.eclipse.xtext.validation.ValidationMessageAcceptor
import robostar.cspm.CspmPackage

class CSPMNamesAreUniqueValidationHelper extends NamesAreUniqueValidationHelper {
	
	override checkUniqueNames(Context context, ValidationMessageAcceptor acceptor) {
		super.doCheckUniqueNames(context, acceptor)
	}
	
	override protected getAssociatedClusterType(EClass eClass) {
		if (CspmPackage.Literals.PATTERN == eClass ||
			CspmPackage.Literals.VARIABLE_PATTERN == eClass
		) return null
		super.getAssociatedClusterType(eClass)
	}
	
	override protected isDuplicate(IEObjectDescription description, IEObjectDescription candidate) {
		
		val dobj = description.EObjectOrProxy
		val cobj = candidate.EObjectOrProxy
		if (dobj instanceof Function) {
			if (cobj instanceof Function) {
				val dcspm = dobj.eContainer
				val ccspm = cobj.eContainer 
				
				if (dcspm == ccspm) {
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
				}
			}
		}
		super.isDuplicate(description, candidate)
	}
	
}