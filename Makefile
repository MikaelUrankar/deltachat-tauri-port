PORTNAME=	deltachat-tauri
DISTVERSIONPREFIX=	v
DISTVERSION=	2.48.0
CATEGORIES=	net-im

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Cross-platform decentralized encrypted messaging service
WWW=		https://delta.chat/

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

LIB_DEPENDS=	libayatana-appindicator3.so:devel/libayatana-appindicator \
		libdbus-1.so:devel/dbus \
		libsoup-3.0.so:devel/libsoup3 \
		libwebkit2gtk-4.1.so:www/webkit2-gtk@41

USES=		cargo electron:40,env gmake gnome nodejs:22,build pkgconfig ssl
USE_GNOME=	cairo gdkpixbuf glib20 gtk30

USE_ELECTRON=	npm:pnpm prefetch extract
NPM_VER=	9.6.0

# Possible to support more arches, but need their binary
# esbuilds included in the npmcache
ONLY_FOR_ARCHS=	amd64

SUB_FILES+=	deltachat.desktop

USE_GITHUB=	yes
GH_ACCOUNT=	deltachat
GH_PROJECT=	deltachat-desktop

MAKE_ENV+=	VERSION_INFO_GIT_REF=${GH_TAGNAME}

CONFLICTS_BUILD=devel/esbuild

post-patch:
	${REINPLACE_CMD} "s|%%PREFIX%%|${PREFIX}|g" ${WRKSRC}/cargo-crates/tauri-utils-2.8.1/src/platform.rs

pre-build:
	# There is no documentation of the build process, this was found in packages/target-tauri/package.json
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${NPM_CMDNAME} --filter=@deltachat-desktop/shared install
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${NPM_CMDNAME} --filter=@deltachat-desktop/frontend install
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${NPM_CMDNAME} --filter=@deltachat-desktop/target-tauri install
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${NPM_CMDNAME} --filter=@deltachat-desktop/target-tauri build4production
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${NPM_CMDNAME} translations:convert

do-install:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/*/deltachat-tauri ${STAGEDIR}${LOCALBASE}/bin

	cd ${WRKSRC} && ${COPYTREE_SHARE} _locales ${STAGEDIR}${DATADIR}/
	${INSTALL} ${WRKDIR}/deltachat.desktop ${STAGEDIR}${PREFIX}/share/applications/deltachat.desktop
	${MKDIR} ${STAGEDIR}${DATADIR}/icons
	${INSTALL} ${FILESDIR}/delta-v7-pathed.svg ${STAGEDIR}${DATADIR}/icons/deltachat.svg

.include <bsd.port.mk>
