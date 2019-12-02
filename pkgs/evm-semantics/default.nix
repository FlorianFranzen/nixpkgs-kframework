{ stdenv, k, ocamlPackages, pandoc, protobuf, zlib }:

stdenv.mkDerivation {
  name = "ethereum-semantics-plugin-ocaml";
  src = /home/ttuegel/evm-semantics;

  buildInputs =
    [ k zlib pandoc ]
    ++ (with ocamlPackages; [
      bn128 cryptokit hex mlgmp ocaml-protoc ocp-ocamlres secp256k1 uuidm zarith
    ]);

  OPAM = "true";

  preConfigure = ''
    rm -r deps/k
    mkdir -p deps/k/k-distribution/target/release
    ln -s ${k} deps/k/k-distribution/target/release/k
  '';

  preBuild = ''
    mkdir -p ''${OCAMLFIND_DESTDIR:?}
  '';

  buildPhase = ''
    runHook preBuild

    make .build/defn/ocaml/driver-kompiled/plugin/semantics.cmxa

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

}
