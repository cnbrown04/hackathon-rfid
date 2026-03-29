/** Single-line full name — non-breaking spaces inside each name and between (no wrapping mid-name). */
export function formatNameSingleLine(firstName: string, lastName: string): string {
	const f = firstName.trim().replace(/\s+/g, "\u00A0");
	const l = lastName.trim().replace(/\s+/g, "\u00A0");
	return `${f}\u00A0${l}`;
}
