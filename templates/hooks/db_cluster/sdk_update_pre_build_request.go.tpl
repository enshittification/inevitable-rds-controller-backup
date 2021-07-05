	if clusterDeleting(latest) {
		msg := "DB cluster is currently being deleted"
		setSyncedCondition(desired, corev1.ConditionFalse, &msg, nil)
		return desired, requeueWaitWhileDeleting
	}
	if clusterCreating(latest) {
		msg := "DB cluster is currently being created"
		setSyncedCondition(desired, corev1.ConditionFalse, &msg, nil)
		return desired, requeueWaitUntilCanModify(latest)
	}
	if clusterHasTerminalStatus(latest) {
		msg := "DB cluster is in '"+*latest.ko.Status.Status+"' status"
		setTerminalCondition(desired, corev1.ConditionTrue, &msg, nil)
		setSyncedCondition(desired, corev1.ConditionTrue, nil, nil)
		return desired, nil
	}