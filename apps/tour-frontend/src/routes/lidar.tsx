import { Environment, OrbitControls, useGLTF } from "@react-three/drei";
import { Canvas, useThree } from "@react-three/fiber";
import { createFileRoute } from "@tanstack/react-router";
import { Suspense, useEffect, useState } from "react";
import * as THREE from "three";
import { connectLidarSocket, type LidarProduct } from "#/lib/lidar-data";

export const Route = createFileRoute("/lidar")({
	component: LidarPage,
});

// Product name → camera target position mapping
// These will need tuning once you see the scene
const PRODUCT_CAMERAS: Record<
	string,
	{ position: [number, number, number]; target: [number, number, number] }
> = {
	hot_shine: { position: [0, 1.6, 1.5], target: [-0.3, 1.6, 0] },
	leather_solution: { position: [0, 1.4, 1.5], target: [0, 1.4, 0] },
	ozark_trail: { position: [0.5, 1.6, 1.5], target: [0.5, 1.6, 0] },
	engraving_kit: { position: [0.5, 1.0, 1.5], target: [0.5, 1.0, 0] },
	armor_all: { position: [-0.2, 0.3, 1.5], target: [-0.2, 0.3, 0] },
};

const DEFAULT_CAMERA = {
	position: [2.93, -0.19, -0.84] as [number, number, number],
	target: [-2.04, -0.77, -0.81] as [number, number, number],
};

function ShelfModel({ activeProduct }: { activeProduct: string | null }) {
	const { scene } = useGLTF("/lidar-mesh.glb");

	useEffect(() => {
		scene.traverse((child) => {
			if (child instanceof THREE.Mesh) {
				const name = child.name.toLowerCase();
				const isActive = activeProduct && name === activeProduct;

				if (isActive) {
					child.material = child.material.clone();
					child.material.emissive = new THREE.Color(0x3b82f6);
					child.material.emissiveIntensity = 0.3;
				} else if (child.userData._originalMaterial) {
					child.material = child.userData._originalMaterial;
				}

				if (!child.userData._originalMaterial) {
					child.userData._originalMaterial = child.material;
				}
			}
		});
	}, [activeProduct, scene]);

	return <primitive object={scene} />;
}

function CameraLogger() {
	const { camera } = useThree();
	useEffect(() => {
		const log = () => {
			const p = camera.position;
			const dir = new THREE.Vector3();
			camera.getWorldDirection(dir);
			const target = p.clone().add(dir.multiplyScalar(5));
			console.log(
				`Camera position: [${p.x.toFixed(2)}, ${p.y.toFixed(2)}, ${p.z.toFixed(2)}]`,
				`\nTarget: [${target.x.toFixed(2)}, ${target.y.toFixed(2)}, ${target.z.toFixed(2)}]`,
			);
		};
		window.addEventListener("keydown", (e) => {
			if (e.key === "p") log();
		});
	}, [camera]);
	return null;
}

function LidarPage() {
	const [activeProduct, setActiveProduct] = useState<string | null>(null);
	const [productInfo, setProductInfo] = useState<LidarProduct | null>(null);

	useEffect(() => {
		const disconnect = connectLidarSocket((product) => {
			setActiveProduct(product.item_desc);
			setProductInfo(product);
		});
		return disconnect;
	}, []);

	const cam = activeProduct
		? PRODUCT_CAMERAS[activeProduct] || DEFAULT_CAMERA
		: DEFAULT_CAMERA;

	return (
		<div className="relative h-[100dvh] w-full bg-black">
			<Canvas
				camera={{ position: cam.position, fov: 50 }}
				style={{ width: "100%", height: "100%" }}
			>
				<Suspense fallback={null}>
					<ambientLight intensity={0.6} />
					<directionalLight position={[5, 5, 5]} intensity={0.8} />
					<ShelfModel activeProduct={activeProduct} />
					<Environment preset="warehouse" />
					<fog attach="fog" args={["#c4a882", 3, 8]} />
					<color attach="background" args={["#c4a882"]} />
					<OrbitControls target={cam.target} />
					<CameraLogger />
				</Suspense>
			</Canvas>

			{/* Product info overlay */}
			{productInfo && (
				<div className="absolute bottom-8 left-8 max-w-sm rounded-xl border border-white/10 bg-black/80 p-6 text-white backdrop-blur-md">
					<h2 className="text-2xl font-semibold">
						{productInfo.item_desc.replace(/_/g, " ")}
					</h2>
					<div className="mt-3 space-y-1 text-sm text-white/70">
						<p>
							<span className="text-white/50">UPC</span> {productInfo.upc}
						</p>
						<p>
							<span className="text-white/50">EPC</span> {productInfo.epc}
						</p>
					</div>
				</div>
			)}

			{/* Reset button */}
			{activeProduct && (
				<button
					type="button"
					onClick={() => {
						setActiveProduct(null);
						setProductInfo(null);
					}}
					className="absolute top-6 right-6 rounded-lg border border-white/10 bg-black/60 px-4 py-2 text-sm text-white backdrop-blur-sm transition hover:bg-white/10"
				>
					Reset view
				</button>
			)}
		</div>
	);
}
