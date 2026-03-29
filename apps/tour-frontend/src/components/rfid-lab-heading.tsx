export function RfidLabHeadingLine() {
	return (
		<>
			Welcome to the{" "}
			<span className="inline-flex items-center gap-2 align-middle sm:gap-3 md:gap-4">
				<img
					src="/auburn-tigers-logo.png"
					alt="Auburn University"
					className="h-10 w-auto shrink-0 object-contain sm:h-14 md:h-16 lg:h-20"
					width={960}
					height={848}
					decoding="async"
				/>
				<span className="whitespace-nowrap">RFID Lab.</span>
			</span>
		</>
	);
}
