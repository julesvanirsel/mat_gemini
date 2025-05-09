%%COMPARE compare entire output directory data files, and input files
%
% absolute and relative tolerance account for slight IEEE-754 based differences,
% including non-associative, non-commutative floating-point arithmetic.
% these parameters are a bit arbitrary.

function compare(outdir, refdir, opts)

% per MZ Oct 17, 2018:
% Ti,Te=1 K
% ne=1e6 m-3
% vi,v2,v3=1 m/s
% J1,J2,J3 = 1e-9

% MZ wants to change what we consider signficant...
% Ti,Te=5 K
% ne=1e7 m-3
% vi,v2,v3=2 m/s
% J1,J2,J3 = 1e-9

arguments
  outdir (1,1) string
  refdir (1,1) string
  opts.only (1,:) string {mustBeMember(opts.only, ["in", "out", "efield", "grid", "precip"])} = ["in", "out"]
  opts.time (1,:) datetime = datetime.empty
end

gemini3d.sys.check_stdlib()

tol.rtol = 1e-5;
tol.rtolN = 1e-5;  % TODO: need to update ref data
tol.rtolT = 1e-5;
tol.rtolJ = 1e-5;
tol.rtolV = 1e-5;
tol.atol = 1e-8;
tol.atolN = 1e9;
tol.atolT = 100;
tol.atolJ = 1e-7;
tol.atolV = 50;

assert(~stdlib.samepath(outdir, refdir), outdir + " and " + refdir + " are the same folder.")

%% check output dirs
if any(opts.only == "out")
  gemini3d.compare.output(outdir, refdir, tol);
end
%% check input dirs
if any(opts.only == "in")
  gemini3d.compare.input(outdir, refdir, tol);
end
if any(opts.only == "efield")
  % TODO: the generated error shouldn't be so big. Need to update ref data?
  gemini3d.compare.efield(outdir, refdir, "abs", tol.atol, "rel", tol.rtol*100, "time", opts.time)
end
if any(opts.only == "precip")
  % TODO: the generated error shouldn't be so big. Need to update ref data?
  gemini3d.compare.precip(outdir, refdir, "abs", tol.atol, "rel", tol.rtol*10, "time", opts.time)
end
if any(opts.only == "grid")
  gemini3d.compare.grid(outdir, refdir, tol.rtol, tol.atol)
end

end % function
