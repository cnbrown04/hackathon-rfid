export function RfidLabHeadingLine() {
	return (
		<span className="inline-flex max-w-full flex-wrap items-center justify-center gap-x-2 gap-y-1 sm:gap-x-3 md:gap-x-4">
			<span className="leading-none">Welcome to the</span>
			<img
				src="/auburn-tigers-logo.png"
				alt="Auburn University"
				className="block h-10 w-auto shrink-0 object-contain sm:h-14 md:h-16 lg:h-20"
				width={960}
				height={848}
				decoding="async"
			/>
			<span className="whitespace-nowrap leading-none">RFID Lab.</span>
		</span>
	);
}
